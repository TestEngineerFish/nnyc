//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: YXViewController {

    var contentScrollView = UIScrollView()
    var headerView: YXExerciseResultView?
    var currentModel: YXLearnMapUnitModel? // 当前单元
    var requestCount = 0

    var newLearnAmount: Int = 0 // 新学单词数
    var reviewLearnAmount: Int = 0 // 复习单词数量
    var bookId: Int? // 书ID
    var unitId: Int? // 单元ID
    var model: YXLearnResultModel?
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.customNavigationBar?.backgroundColor = UIColor.clear
        self.bindData()
    }

    private func createSubviews() {
        guard let _currentModel = self.currentModel else {
            return
        }
        
        // 内容视图,支持滑动
        self.view.addSubview(self.contentScrollView)
        
        let contentScrollViewH = screenHeight - AS(68 + kSafeBottomMargin)
        self.contentScrollView.contentSize = CGSize(width: screenWidth, height: contentScrollViewH)
        self.contentScrollView.isScrollEnabled = true
        self.contentScrollView.showsVerticalScrollIndicator   = false
        self.contentScrollView.showsHorizontalScrollIndicator = false
        self.contentScrollView.frame = CGRect(x: 0, y: AS(68 + kSafeBottomMargin), width: screenWidth, height: contentScrollViewH)

        
        
        // 结果视图
        let newModel = YXExerciseResultDisplayModel.displayModel(unitId: unitId ?? 0, newStudyWordCount: newLearnAmount, reviewWordCount: reviewLearnAmount, model: model!)
        headerView = YXExerciseResultView(model: newModel)
        self.contentScrollView.addSubview(headerView!)
//        headerView?.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(headerView!.viewHeight()) //AdaptSize(244)
//        }
        self.headerView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerView!.viewHeight())
        self.headerView?.processEvent = { [weak self] in
            self?.punchEvent()
        }
    
    }

    /// 设置任务地图
    private func createTaskMap() {
        guard let modelArray = self.model?.unitList else {
            return
        }
        let w = screenWidth - AS(40)
        let h = screenHeight - AS(68 + kSafeBottomMargin) - headerView!.viewHeight() - AS(10 + kSafeBottomMargin + 21)
        // 任务地图视图
        let taskMapViewSize = CGSize(width: w, height: h)
        let taskMapViewPoint = CGPoint(x: AS(20), y: headerView!.viewHeight() + AS(10))
        let taskMapFrame    = CGRect(origin: taskMapViewPoint, size: taskMapViewSize)
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
//        taskMapView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.size.equalTo(taskMapViewSize)
//            make.bottom.equalToSuperview().offset(AS(-kSafeBottomMargin))
//        }
        taskMapView.layer.setDefaultShadow()
    }

    private func bindData() {
        guard let bookId = self.bookId, let unitId = self.unitId else {
            return
        }
        let request = YXExerciseRequest.learnResult(bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else {
                return
            }
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
                self.model = response.data
                self.currentModel = self.model?.unitList?.filter({ (model) -> Bool in
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
    @objc private func punchEvent() {
        guard let model = self.model else {
            YXUtils.showHUD(kWindow, title: "数据请求失败，请稍后再试～")
            return
        }
        let vc = YXShareViewController()
        vc.shareType   = .learnResult
        vc.wordsAmount = model.studyDay
        vc.daysAmount  = model.allWordCount
        vc.hideCoin    = !model.isShowCoin
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
