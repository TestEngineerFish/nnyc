//
//  MakeReviewPlanViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
protocol YXMakeReviewPlanProtocol: NSObjectProtocol {
    func selectedWord(_ word: YXReviewWordModel)
    func unselectWord(_ word: YXReviewWordModel)
    func isContionWord(_ word: YXReviewWordModel) -> Bool
}

class MakeReviewPlanViewController: UIViewController, BPSegmentDataSource, YXMakeReviewPlanProtocol {

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
    var selectedWordView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray1
        return view
    }()
    var makePlanButton: YXButton = {
        let button = YXButton()
        button.setTitle("创建复习计划", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.setDefaultShadow()
        return view
    }()

    // ---- 数据对象
    var model: YXReviewBookModel?
    var selectedWords: [YXReviewWordModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        segmentControllerView.delegate = self
        self.createSubviews()
        self.getData()
    }

    private func createSubviews() {
        self.title = "选择单词"
        self.view.addSubview(segmentControllerView)
        self.view.addSubview(bottomView)
        self.bottomView.addSubview(makePlanButton)
        self.view.addSubview(selectedWordView)

        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentControllerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let makeSize = CGSize(width: AdaptSize(226), height: AdaptSize(42))
        makePlanButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(makeSize)
        }

        selectedWordView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.size.equalTo(CGSize(width: AdaptSize(154), height: AdaptSize(54)))
            make.bottom.equalTo(bottomView.snp.top).offset(AdaptSize(-30))
        }
        selectedWordView.backgroundColor = UIColor.hex(0xFFF4E9)
        makePlanButton.backgroundColor = UIColor.gradientColor(with: makeSize, colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
        makePlanButton.layer.cornerRadius = makeSize.height / 2
    }

    private func getData() {
        let request = YXReviewRequest.reviewBookList
        YYNetworkService.default.request(YYStructResponse<YXReviewBookModel>.self, request: request, success: { (response) in
            self.model = response.data
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
        let itemView  = YXWordBookItemView(itemModel, frame: CGRect.zero)
        return itemView
    }
    /// 自定义Content视图
    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
        guard let listModel = self.model?.currentModel else {
            return UIView()
        }
        let tableView = YXReviewUnitListView(listModel, frame: CGRect.zero)
        tableView.delegate = self
        return tableView
    }

    // MARK: ==== YXMakeReviewPlanProtocol ====
    func selectedWord(_ word: YXReviewWordModel) {
        self.selectedWords.append(word)
    }

    func unselectWord(_ word: YXReviewWordModel) {
        guard let firstIndex = self.selectedWords.firstIndex(of: word) else {
            return
        }
        self.selectedWords.remove(at: firstIndex)
    }

    func isContionWord(_ word: YXReviewWordModel) -> Bool {
        return self.selectedWords.contains(word)
    }

}