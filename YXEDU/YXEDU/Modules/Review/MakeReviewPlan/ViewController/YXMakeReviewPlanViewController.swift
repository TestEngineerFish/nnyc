//
//  YXMakeReviewPlanViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

class YXMakeReviewPlanViewController: YXViewController, BPSegmentDataSource {

    // ---- 子视图
    var segmentControllerView: BPSegmentControllerView = {
        let h = screenHeight - kNavHeight - AdaptSize(60) - kSafeBottomMargin
        var config = BPSegmentConfig()
        config.headerHeight       = AdaptSize(78)
        config.headerItemSize     = CGSize(width: AdaptSize(60), height: AdaptSize(78))
        config.headerItemSpacing  = AdaptSize(10)
        config.contentItemSize    = CGSize(width: screenWidth, height: h - config.headerHeight)
        config.contentItemSpacing = CGFloat.zero
        let segmentFrame = CGRect(x: 0, y: kNavHeight, width: screenWidth, height: h)
        let segmentControllerView = BPSegmentControllerView(config, frame: segmentFrame)
        return segmentControllerView
    }()
    var selectedWordsListView = YXReviewSelectedWordsListView()

    var bottomView = YXReviewBottomView()

    // ---- 数据对象
    var model: YXReviewBookModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.bindData()
        self.createSubviews()
        self.requestBooksList()
    }

    private func createSubviews() {
        self.customNavigationBar?.title = "选择单词"
        self.view.addSubview(segmentControllerView)
        self.view.addSubview(bottomView)
        self.view.addSubview(selectedWordsListView)
        self.view.backgroundColor = UIColor.white
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(kSafeBottomMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(60) + kSafeBottomMargin)
        }

        selectedWordsListView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.width.equalTo(AdaptSize(155))
            make.height.equalTo(selectedWordsListView.defalutHeight)
            make.bottom.equalToSuperview().offset(AdaptSize(-90))
        }
    }

    private func bindData() {
        self.segmentControllerView.delegate           = self
        self.selectedWordsListView.delegateBottomView = self.bottomView
        self.bottomView.makeButton.addTarget(self, action: #selector(makeReivewPlan), for: .touchUpInside)
    }

    // MARK: ==== Request ====

    private func requestBooksList() {
        let request = YXReviewRequest.reviewBookList
        YYNetworkService.default.request(YYStructResponse<YXReviewBookModel>.self, request: request, success: { (response) in
            guard let _model = response.data else {
                return
            }
            for (index, bookModel) in _model.list.enumerated() {
                if bookModel.isLearning {
                    _model.modelDict.updateValue(_model.currentModel, forKey: "\(bookModel.id)")
                    bookModel.isSelected = true
                   self.segmentControllerView.selectItem(with: IndexPath(item: index, section: 0))
                }
            }
            self.model = _model

            self.segmentControllerView.reloadData()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    private func requestWordsList(_ bookId: Int, type: Int) {
        let request = YXReviewRequest.reviewWordList(bookId: bookId, bookType: type)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { (response) in
            guard let unitModelList = response.dataArray else {
                return
            }
            self.model?.modelDict.updateValue(unitModelList, forKey: "\(bookId)")
            self.segmentControllerView.reloadData()
            // 如果当前请求的页面还停留在主页面,则刷新显示
            for (row, cell) in self.segmentControllerView.contentScrollView.visibleCells.enumerated() {
                if cell.tag == bookId {
                    self.segmentControllerView.contentScrollView.reloadItems(at: [IndexPath(row: row, section: 0)])
                }
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    private func requestMakeReviewPlan(_ name: String?) {
        let name = name ?? ""
        let idsList = self.selectedWordsListView.wordsModelList.map { (wordModel) -> Int in
            return wordModel.id
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: idsList, options: []) else {
            return
        }
        let idsStr = String(data: jsonData, encoding: String.Encoding.utf8)!
        let request = YXReviewRequest.makeReviewPlan(name: name, code: nil, idsList: idsStr)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXReviewUnitModel>.self, request: request, success: { (response) in
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            // 如果名称重复错误,也需要处理哦
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====
    @objc private func makeReivewPlan() {
        // 显示弹框
        let name = self.getPlanName()
        let alertView = YXAlertView(type: .inputable, placeholder: name)
        alertView.doneClosure = { (text: String?) in
            self.requestMakeReviewPlan(text)
        }
        alertView.show()
    }

    // MARK: ==== Tools ====
    private func getPlanName() -> String {
        var bookName = "我的复习计划"
        var bookIdList: Set<Int> = []
        self.selectedWordsListView.wordsModelList.forEach { (wordModel) in
            bookIdList.insert(wordModel.bookId)
        }
        if bookIdList.count > 1 {
            return bookName
        } else {
            guard let list = self.model?.list, let bookId = bookIdList.first else {
                return bookName
            }
            list.forEach { (bookModel) in
                if bookModel.id == bookId {
                    if bookModel.type == 1 {
                        bookName = "错词本复习计划"
                    } else if bookModel.type == 2 {
                        bookName = "收藏单词复习计划"
                    }
                }
            }
            return bookName
        }

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
        if let unitModelList = model.modelDict["\(bookModel.id)"] {
            let unitListView = YXReviewUnitListView(unitModelList, frame: CGRect.zero)
            unitListView.tag      = bookModel.id
            unitListView.delegate = self.selectedWordsListView
            self.selectedWordsListView.delegate = unitListView
            return unitListView
        } else {
            self.requestWordsList(bookModel.id, type: bookModel.type)
            return UIView()
        }
    }

    func segment(didSelectRowAt indexPath: IndexPath, previousSelectRowAt preIndexPath: IndexPath) {
        guard let model = self.model else {
            return
        }
        model.list[indexPath.row].isSelected    = true
        model.list[preIndexPath.row].isSelected = false
        self.segmentControllerView.reloadData()
    }
}
