//
//  YXMakeReviewPlanViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

protocol YXMakeReviewPlanProtocol: NSObjectProtocol {
    func makeReivewPlanFinised()
}

class YXMakeReviewPlanViewController: YXViewController, BPSegmentDataSource, YXReviewSelectedArrowProtocol, YXReviewSelectedWordsListViewProtocol {

    // ---- 子视图
    var segmentControllerView: BPSegmentControllerView = {
        let h = screenHeight - kNavHeight - AdaptIconSize(60) - kSafeBottomMargin
        var config = BPSegmentConfig()
        config.headerHeight       = AdaptIconSize(93)
        config.headerItemSize     = CGSize(width: AdaptIconSize(60), height: AdaptIconSize(93))
        config.headerItemSpacing  = AdaptIconSize(10)
        config.contentItemSize    = CGSize(width: screenWidth, height: h - config.headerHeight)
        config.contentItemSpacing = CGFloat.zero
        let segmentFrame = CGRect(x: 0, y: kNavHeight, width: screenWidth, height: h)
        let segmentControllerView = BPSegmentControllerView(config, frame: segmentFrame)
        return segmentControllerView
    }()
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        view.isHidden        = true
        return view
    }()
    let searchView            = YXReviewSearchView()
    var selectedWordsListView = YXReviewSelectedWordsListView()
    var bottomView            = YXReviewBottomView()
    weak var delegate: YXMakeReviewPlanProtocol?
    weak var reviewDelegate: YXReviewUnitListUpdateProtocol?

    // ---- 数据对象
    var model: YXReviewBookModel?
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.bindData()
        self.createSubviews()
        self.requestBooksList()
    }

    private func createSubviews() {
        self.searchView.layer.opacity = 0
        self.customNavigationBar?.title = "选择单词"
        self.customNavigationBar?.rightButton.setImage(UIImage(named: "review_search"), for: .normal)
        self.customNavigationBar?.rightButtonAction = { [weak self] in
            guard let self = self else { return }
            self.showSearchView()
        }
        self.view.addSubview(segmentControllerView)
        self.view.addSubview(bottomView)
        self.view.addSubview(searchView)
        self.view.addSubview(backgroundView)
        self.view.addSubview(selectedWordsListView)
        self.view.backgroundColor = UIColor.white
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptIconSize(60) + kSafeBottomMargin)
        }
        searchView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        selectedWordsListView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptIconSize(-10))
            make.width.equalTo(AdaptIconSize(155))
            make.height.equalTo(selectedWordsListView.defalutHeight)
            make.bottom.equalTo(bottomView.snp.top).offset(AdaptIconSize(-30))
        }
    }

    private func bindData() {
        self.searchView.unitListDelegate              = self.selectedWordsListView
        self.searchView.selectedDelegate              = self
        self.segmentControllerView.delegate           = self
        self.selectedWordsListView.delegateArrow      = self
        self.selectedWordsListView.delegateBottomView = self.bottomView
        self.bottomView.makeButton.addTarget(self, action: #selector(makeReivewPlan), for: .touchUpInside)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(hideBackgroundView))
        self.backgroundView.addGestureRecognizer(tapAction)
    }

    // MARK: ==== Request ====


    /// 请求书列表
    private func requestBooksList() {
        let request = YXReviewRequest.reviewBookList
        YYNetworkService.default.request(YYStructResponse<YXReviewBookModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let _model = response.data else {
                return
            }
            for (index, bookModel) in _model.list.enumerated() {
                if bookModel.isLearning {
                    _model.modelDict.updateValue(_model.currentModel, forKey: "\(bookModel.id)")
                    self.segmentControllerView.lastSelectedIndex = IndexPath(item: index, section: 0)
                }
            }
            self.model = _model
            self.segmentControllerView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 创建复习计划
    /// - Parameter name: 复习计划名称
    private func requestMakeReviewPlan(_ name: String) {
        let idsList = self.selectedWordsListView.wordsModelList.map { (wordModel) -> Int in
            return wordModel.id
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: idsList, options: []) else {
            return
        }
        let idsStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        let request = YXReviewRequest.makeReviewPlan(name: name, code: nil, idsList: idsStr)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.delegate?.makeReivewPlanFinised()
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            if error.code == 101 {
                let alertView = YXAlertView(type: .normal)
                alertView.descriptionLabel.text   = error.message
                alertView.shouldOnlyShowOneButton = true
                alertView.show()
            } else {
                YXUtils.showHUD(self.view, title: error.message)
            }
        }
    }

    // MARK: ==== Event ====
    @objc private func makeReivewPlan() {
        if self.selectedWordsListView.wordsModelList.count < 4 {
            YXUtils.showHUD(self.view, title: "请至少选择4个单词")
        } else {
            // 显示弹框
            let name = YXReviewDataManager.makePlanName(defailt: self.getPlanName())
            let alertView = YXAlertView(type: .inputable, placeholder: name)
            alertView.shouldOnlyShowOneButton = false
            alertView.titleLabel.text = "请设置词单名称"
            alertView.doneClosure = { (text: String?) in
                guard let _text = text, !_text.isEmpty else {
                    let alertView = YXAlertView(type: .normal)
                    alertView.descriptionLabel.text   = "词单名称不能为空"
                    alertView.shouldOnlyShowOneButton = true
                    alertView.show()
                    return
                }
                self.requestMakeReviewPlan(_text)
            }
            alertView.show()
        }
    }

    @objc private func hideBackgroundView() {
        self.closeDownList()
        self.selectedWordsListView.closeDownList()
    }
    
    private func showSearchView() {
        guard let _model = self.model else {
            return
        }
        
        let bookModel = _model.list[self.selectedIndex]
        self.searchView.bookModel = bookModel

        var result = false
        // 下载当前词书所有单元
        if let unitModelList = _model.modelDict["\(bookModel.id)"] {
            self.searchView.unitListModel = unitModelList
            result = true
        }

        if result {
            self.searchView.updateInfo()
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self = self else { return }
                self.searchView.layer.opacity = 1.0
            }
        } else {
            YXUtils.showHUD(self.view, title: "当前书未加载完成，请稍后再试～")
        }

    }

    // MARK: ==== Tools ====
    private func getPlanName() -> String {
        var bookName = ""
        var bookIdList: Set<Int> = []
        self.selectedWordsListView.wordsModelList.forEach { (wordModel) in
            bookIdList.insert(wordModel.bookId)
        }
        if bookIdList.count > 1 {
            // 如果只选择了多本书中的单词
            bookName = "我的词单"
        } else {
            // 如果只选择了一本书中的单词
            guard let list = self.model?.list, let bookId = bookIdList.first else {
                return bookName
            }
            list.forEach { (bookModel) in
                if bookModel.id == bookId {
                    if bookModel.type == .wrongList {
                        bookName = "错词本词单"
                    } else if bookModel.type == .collect {
                        bookName = "收藏单词词单"
                    } else if bookModel.type == .unit {
                        bookName = bookModel.name + "词单"
                    } else {
                        bookName = "我的词单"
                    }
                }
            }
        }
        // 去除重复
        var isExist = true
        var repeatNumber = 0
        var editBookName = bookName
        guard let list = self.model?.list else {
            return bookName
        }
        while isExist {
            let existModel = list.filter { (bookModel) -> Bool in
                return bookModel.name == editBookName
            }.first
            if existModel != nil {
                if repeatNumber > 0 {
                    editBookName.removeLast()
                }
                repeatNumber += 1
                editBookName += "\(repeatNumber)"
            } else {
                isExist = false
                bookName = editBookName
            }
        }
        return bookName
    }

    // MARK: ==== BPSegmentDataSource ====

    func pagesNumber() -> Int {
        return self.model?.list.count ?? 0
    }

    /// 自定义Item视图
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        guard let model = self.model else {
            return UIView()
        }
        let itemModel = model.list[indexPath.item]
        let itemView  = YXReviewBookItem()
        itemView.bindData(itemModel)
        return itemView
    }
    /// 自定义Content视图
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        guard let model = self.model, indexPath.row < model.list.count else {
            return UIView()
        }
        let bookModel = model.list[indexPath.row]
        let unitListView = YXReviewUnitListView(model, bookModel: bookModel, frame: .zero)
        unitListView.delegate               = self.selectedWordsListView
        self.reviewDelegate                 = unitListView
        self.selectedWordsListView.delegate = self
        return unitListView
    }

    func segment(didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath) {
        guard let model = self.model else {
            return
        }
        self.selectedIndex = indexPath.row
        model.list[preIndexPath.row].isSelected = false
        model.list[indexPath.row].isSelected    = true
        self.segmentControllerView.headerScrollView?.reloadData()
    }

    // MARK: ==== YXReviewSelectedArrowProtocol ====
    func closeDownList() {
        self.backgroundView.isHidden = true
    }

    func openUpList() {
        self.backgroundView.isHidden = false
    }

    // MARK: ==== YXReviewSelectedWordsListViewProtocol ====
    func unselect(_ word: YXReviewWordModel) {
        if self.searchView.layer.opacity > 0 {
            self.searchView.tableView.reloadData()
        }
        self.reviewDelegate?.updateSelectStatus(word)
    }
    
    func selected(_ word: YXReviewWordModel) {
        self.reviewDelegate?.updateSelectStatus(word)
    }
}
