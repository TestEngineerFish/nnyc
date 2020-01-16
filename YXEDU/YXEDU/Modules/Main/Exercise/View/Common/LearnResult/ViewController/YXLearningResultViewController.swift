//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: YXViewController {
    
    var backButton        = BiggerClickAreaButton()
    var headerView: YXExerciseResultView?
    var taskMapView: YXTaskMapView?
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
        self.customNavigationBar?.isHidden = true
        self.bindData()
    }
    
    
    private func loadSubViews() {
        createSubviews()
        bindProperty()
        setLayout()
    }
    
    
    private func createSubviews() {
        // 结果视图
        let newModel = YXExerciseResultDisplayModel.displayModel(unitId: unitId ?? 0, newStudyWordCount: newLearnAmount, reviewWordCount: reviewLearnAmount, model: model!)
        headerView = YXExerciseResultView(model: newModel)
        self.view.addSubview(headerView!)
        
        // 返回按钮
        self.view.addSubview(backButton)
 
        // 设置任务地图
        self.createTaskMap()
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
        let taskMapFrame    = CGRect(origin: .zero, size: taskMapViewSize)
        taskMapView     = YXTaskMapView(modelArray, frame: taskMapFrame, currentModel: currentModel)
        self.view.addSubview(taskMapView!)
    }
    
    
    private func bindProperty() {
        backButton.setImage(UIImage(named: "back_gray"), for: .normal)
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        
        self.headerView?.processEvent = { [weak self] in
            self?.punchEvent()
        }
        
        taskMapView?.layer.setDefaultShadow()
        taskMapView?.backgroundColor    = UIColor.white
        taskMapView?.layer.cornerRadius = 6
        taskMapView?.learnNewUnit = { [weak self] (unitId: Int?) -> Void in
            guard let self = self, let id = unitId else {
                return
            }
            self.learnUnit(id)
        }
        
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(AS(14))
            make.top.equalTo(AS(32 + kSafeBottomMargin))
            make.width.height.equalTo(AS(22))
        }
        
        headerView?.snp.makeConstraints { (make) in
            make.top.equalTo(AS(68 + kSafeBottomMargin))
            make.left.right.equalToSuperview()
            make.height.equalTo(headerView?.viewHeight() ?? 0)
        }
        
        taskMapView?.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(taskMapView?.size ?? CGSize.zero)
            make.bottom.equalToSuperview().offset(AS(-kSafeBottomMargin - 21))
        }
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
                self.loadSubViews()
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
//        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func punchEvent() {
        guard let model = self.model else {
            YXUtils.showHUD(kWindow, title: "数据请求失败，请稍后再试～")
            return
        }
        let vc = YXShareViewController()
        vc.shareType   = .learnResult
        vc.wordsAmount = model.allWordCount
        vc.daysAmount  = model.studyDay
        vc.hideCoin    = !model.isShowCoin
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
