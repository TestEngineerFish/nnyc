//
//  MakeReviewPlanViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


class MakeReviewPlanViewController: UIViewController, BPSegmentDataSource {

    // ---- 子视图
    var segmentControllerView: BPSegmentControllerView = {
        let h = screenHeight - kNavHeight - AdaptSize(60) - kSafeBottomMargin
        var config = BPSegmentConfig()
        config.headerHeight       = AdaptSize(96)
        config.headerItemSize     = CGSize(width: AdaptSize(60), height: AdaptSize(96))
        config.headerItemSpacing  = AdaptSize(10)
        config.contentItemSize    = CGSize(width: screenWidth, height: h - config.headerHeight)
        config.contentItemSpacing = CGFloat.zero
        let segmentFrame = CGRect(x: 0, y: 0, width: screenWidth, height: h)
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
        self.getData()

    }

    private func createSubviews() {
        self.title = "选择单词"
        self.view.addSubview(segmentControllerView)
        self.view.addSubview(bottomView)
        self.view.addSubview(selectedWordsListView)

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
        self.selectedWordsListView.delegateBottomView = self.bottomView
        self.segmentControllerView.delegate = self
    }

    private func getData() {
        let request = YXReviewRequest.reviewBookList
        YYNetworkService.default.request(YYStructResponse<YXReviewBookModel>.self, request: request, success: { (response) in
            guard let _model = response.data else {
                return
            }
            _model.list.forEach { (bookModel) in
                if bookModel.isLearning {
                    _model.modelDict.updateValue(_model.currentModel, forKey: "\(bookModel.id)")
                }
            }
            self.model = _model
            self.segmentControllerView.reloadData()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== BPSegmentDataSource ====
    /// 首选中Index
    func firstSelectedIndex() -> IndexPath? {
        return IndexPath(item: 0, section: 0)
    }

    func pagesNumber() -> Int {
        return self.model?.list.count ?? 0
    }

    /// 自定义Item视图
    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
        guard let model = self.model else {
            return UIView()
        }
        let itemModel = model.list[indexPath.item]
        let itemView  = YXReviewBookItem(itemModel, frame: CGRect.zero)
        return itemView
    }
    /// 自定义Content视图
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        guard let model = self.model, indexPath.row < model.list.count else {
            return UIView()
        }
        let bookId = model.list[indexPath.row].id
        guard let unitModelList = model.modelDict["\(bookId)"] else {
            return UIView()
        }
        let tableView = YXReviewUnitListView(unitModelList, frame: CGRect.zero)
        tableView.tag      = bookId
        tableView.delegate = self.selectedWordsListView
        self.selectedWordsListView.delegate = tableView
        return tableView
    }
}
