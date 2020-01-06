//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: UIViewController {

    var backButton        = UIButton()
    var contentScrollView = UIScrollView()
    var punchButton       = YXButton()
    var mapModelList: [YXLearnMapUnitModel]? // 总单元
    var currentModel: YXLearnMapUnitModel? // 当前单元
    var requestCount = 0

    var newLearnAmount: Int = 0 // 新学单词数
    var reviewLearnAmount: Int = 0 // 复习单词数量
    var allWordCount = 0
    var daysAmount = 0
    var bookId: Int? // 书ID
    var unitId: Int? // 单元ID

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.bindData()
    }

    private func createSubviews() {
        guard let _currentModel = self.currentModel else {
            return
        }

        // 结果视图
        let headerView = YXLearningResultHeaderView(_currentModel, newAmount: newLearnAmount, reviewAmount: reviewLearnAmount)
        self.contentScrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(244))
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(26))
        }

        // 内容视图,支持滑动
        self.view.addSubview(self.contentScrollView)
        self.contentScrollView.isScrollEnabled = true
        self.contentScrollView.showsVerticalScrollIndicator   = false
        self.contentScrollView.showsHorizontalScrollIndicator = false

        self.contentScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }

        // 返回按钮
        backButton.setImage(UIImage(named: "closeBtn"), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.width.height.equalTo(AdaptSize(28))
        }
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)

        // 打卡按钮
        let punchSize = CGSize(width: screenWidth - AdaptSize(100), height: AdaptSize(42))
        punchButton.setTitle("打卡分享", for: .normal)
        punchButton.setTitleColor(UIColor.white, for: .normal)
        punchButton.size = punchSize
        punchButton.cornerRadius = punchButton.size.height/2
        punchButton.layer.setGradient(colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
        punchButton.addTarget(self, action: #selector(punchEvent), for: .touchUpInside)
        self.view.addSubview(punchButton)
        punchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-AdaptSize(30) - kSafeBottomMargin)
            make.size.equalTo(punchSize)
        }
    }

    /// 设置任务地图
    private func createTaskMap() {
        guard let modelArray = self.mapModelList else {
            return
        }
        // 任务地图视图
        let taskMapViewSize = CGSize(width: AdaptSize(307), height: AdaptSize(245))
        let taskMapFrame    = CGRect(origin: CGPoint.zero, size: taskMapViewSize)
        let taskMapView     = YXTaskMapView(modelArray, frame: taskMapFrame, currentModel: currentModel)
        taskMapView.learnNewUnit = { [weak self] (unitId: Int?) -> Void in
            guard let self = self, let id = unitId else {
                return
            }
            self.learnUnit(id)
        }
        taskMapView.backgroundColor    = UIColor.white
        taskMapView.layer.cornerRadius = 6
        self.contentScrollView.addSubview(taskMapView)
        taskMapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(300))
            make.bottom.equalToSuperview().offset(AdaptSize(100))
            make.size.equalTo(taskMapViewSize)
            make.centerX.equalToSuperview()
        }
        taskMapView.layer.setDefaultShadow()

        let taskMapLabelImageView = UIImageView()
        taskMapLabelImageView.image = UIImage(named: "taskMapLabel")
        self.view.addSubview(taskMapLabelImageView)
        taskMapLabelImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(taskMapView.snp.top).offset(-6)
            make.left.equalTo(taskMapView)
            make.width.equalTo(48)
            make.height.equalTo(10)
        }
        let contentScrollViewH = kStatusBarHeight + AdaptSize(300) + taskMapViewSize.height + AdaptSize(100)
        self.contentScrollView.contentSize = CGSize(width: contentScrollView.width, height: contentScrollViewH)
    }

    private func bindData() {
        guard let bookId = self.bookId, let unitId = self.unitId else {
            return
        }
        let request = YXExerciseRequest.learnResult(bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            // 如果后台还在计算,则重新请求
            if response.data?.countStatus == .some(.ing) {
                // 如果请求次数超过五次,则退出
                if self.requestCount >= 5 {
                    YXUtils.showHUD(self.view, title: "后台繁忙,请稍后重试")
                } else {
                    self.requestCount += 1
                    self.bindData()
                }
            } else {
                self.allWordCount = response.data?.allWordCount ?? 0
                self.mapModelList = response.data?.unitList
                self.currentModel = self.mapModelList?.filter({ (model) -> Bool in
                    return model.unitID == unitId
                }).first
                self.createSubviews()
                self.createTaskMap()
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    /// 学习新单元
    private func learnUnit(_ unitId: Int) {
        guard let uuidStr = YXConfigure.shared()?.uuid, let bookId = self.bookId else {
            return
        }
        let request = YXExerciseRequest.addUserBook(userId: uuidStr, bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            print("学习新单元成功")
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: Event

    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func punchEvent() {
        let vc = YXShareViewController()
        vc.shareType   = .learnResult
        vc.wordsAmount = self.allWordCount
        vc.daysAmount  = self.daysAmount
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
