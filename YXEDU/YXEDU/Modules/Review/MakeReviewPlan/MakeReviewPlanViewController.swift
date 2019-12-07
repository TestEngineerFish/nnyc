//
//  MakeReviewPlanViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class MakeReviewPlanViewController: UIViewController, BPSegmentDataSource {

    var segmentControllerView: BPSegmentControllerView = {
        let h = screenHeight - kNavHeight - AdaptSize(60) - kSafeBottomMargin
        var config = BPSegmentConfig()
        config.headerHeight       = AdaptSize(96)
        config.headerItemSize     = CGSize(width: AdaptSize(60), height: AdaptSize(96))
        config.headerItemSpacing  = AdaptSize(10)
        config.contentItemSize    = CGSize(width: screenWidth, height: h - config.headerHeight)
        config.contentItemSpacing = CGFloat.zero
        config.pageNumbers        = 10
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        segmentControllerView.delegate = self
        self.createSubviews()
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
        makePlanButton.backgroundColor = UIColor.gradientColor(with: makeSize, colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)

        selectedWordView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.size.equalTo(CGSize(width: AdaptSize(154), height: AdaptSize(54)))
            make.bottom.equalTo(bottomView.snp.top).offset(AdaptSize(-30))
        }
    }

    // MARK: ==== BPSegmentDataSource ====
    /// 首选中Index
    func firstSelectedIndex() -> IndexPath? {
        return IndexPath(item: 0, section: 0)
    }

//    /// 自定义Item视图
//    func segment(_ segment: BPSegmentView, itemForRowAt indexPath: IndexPath) -> UIView {
//
//    }
//    /// 自定义Content视图
//    func segment(_ segment: BPSegmentView, contentForRowAt indexPath: IndexPath) -> UIView {
//
//    }

}
