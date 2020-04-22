//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: YXViewController {
    
    var backButton = BiggerClickAreaButton()
    var headerView: YXExerciseResultView?
    var taskMapView: YXTaskMapView?
    var leftImageView = UIImageView()
    var rightImageView = UIImageView()
    var contentScrollView = UIScrollView()

    var currentUnitIndex = 0
    var requestCount = 0
    var newLearnAmount: Int = 0 // 新学单词数
    var reviewLearnAmount: Int = 0 // 复习单词数量
    var bookId: Int? // 书ID
    var unitId: Int? // 单元ID
    var model: YXLearnResultModel?

    var shareFinished = false
    var loadingView = YXExerciseResultLoadingView()
    var unitMapView: YXUnitMapView?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.customNavigationBar?.isHidden = true
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(kSafeBottomMargin + 123))
            make.centerX.width.equalToSuperview()
            make.height.equalTo(AS(120))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.bindData()
        }
    }

    private func loadSubViews() {
        createSubviews()
        bindProperty()
        setLayout()
    }

    override func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(shareResult(notification:)), name: YXNotification.kShareResult, object: nil)
    }

    private func createSubviews() {
        self.view.addSubview(self.contentScrollView)
        
        // 结果视图
        let newModel = YXExerciseResultDisplayModel.displayModel(newStudyWordCount: newLearnAmount, reviewWordCount: reviewLearnAmount, model: model!)
        headerView = YXExerciseResultView(model: newModel)
        self.contentScrollView.addSubview(headerView!)
        
        // 返回按钮
        self.view.addSubview(backButton)
 
        // 设置任务地图
        self.initUnitMap()
        
        self.contentScrollView.addSubview(leftImageView)
        self.contentScrollView.addSubview(rightImageView)
    }

    private func initUnitMap() {
        guard let model = self.model, let resultView = self.headerView else {return}
        let mapSize = CGSize(width: AdaptSize(333), height: AdaptSize(192))
        self.unitMapView = YXUnitMapView(unitModelList: model.unitList ?? [], currentUnitIndex: self.currentUnitIndex, moveNext: model.status, frame: CGRect(origin: .zero, size: mapSize))
//        self.unitMapView = YXUnitMapView(unitModelList: model.unitList ?? [], currentUnitIndex: 6, moveNext: model.status, frame: CGRect(origin: .zero, size: mapSize))
        self.contentScrollView.addSubview(unitMapView!)
        unitMapView!.snp.makeConstraints { (make) in
            make.size.equalTo(mapSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(resultView.snp.bottom).offset(AdaptSize(10))
        }
        let leftBarImageView  = UIImageView(image: UIImage(named: "linkBar"))
        let rightBarImageView = UIImageView(image: UIImage(named: "linkBar"))
        self.contentScrollView.addSubview(leftBarImageView)
        self.contentScrollView.addSubview(rightBarImageView)
        leftBarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(resultView.snp.bottom).offset(AdaptSize(-15))
            make.left.equalTo(unitMapView!).offset(AdaptSize(13))
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(41)))
        }
        rightBarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(leftBarImageView)
            make.right.equalTo(unitMapView!).offset(AdaptSize(-13))
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(41)))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.contentScrollView.contentSize = CGSize(width:self.view.width, height:self.unitMapView!.frame.maxY + AdaptSize(15) + kSafeBottomMargin)
        }
    }
    
    private func bindProperty() {
        self.contentScrollView.isScrollEnabled                = true
        self.contentScrollView.showsVerticalScrollIndicator   = false
        self.contentScrollView.showsHorizontalScrollIndicator = false
        
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
        
        leftImageView.image = UIImage(named: "review_result_connection")
        rightImageView.image = UIImage(named: "review_result_connection")
    }
    
    private func setLayout() {
        let headerHeight = headerView?.viewHeight() ?? 0
        let contentHeight = AS(68 + kSafeBottomMargin) + headerHeight + AS(31) + AS(245)
        
        self.contentScrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.contentScrollView.contentSize = CGSize(width: screenWidth, height: contentHeight)

        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(AS(14))
            make.top.equalTo(AS(32 + kSafeBottomMargin))
            make.width.height.equalTo(AS(22))
        }
        
        headerView?.snp.makeConstraints { (make) in
            make.top.equalTo(AS(68 + kSafeBottomMargin))
            make.width.centerX.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
                
        if headerView != nil {
            taskMapView?.snp.makeConstraints { (make) in
                make.top.equalTo(headerView!.snp.bottom).offset(AS(10))
                make.centerX.equalToSuperview()
                make.size.equalTo(taskMapView?.size ?? CGSize.zero)
            }
            
            leftImageView.snp.makeConstraints { (make) in
                make.top.equalTo(headerView!.snp.bottom).offset(AS(-15))
                make.left.equalTo(AS(33))
                make.width.equalTo(AS(16))
                make.height.equalTo(AS(41))
            }
            
            rightImageView.snp.makeConstraints { (make) in
                make.top.height.width.equalTo(leftImageView)
                make.right.equalTo(headerView!).offset(AS(-33))
            }
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
                self.loadingView.removeFromSuperview()
                self.model = response.data
                if let _unitModelList = self.model?.unitList {
                    for (index, unitModel) in _unitModelList.enumerated() {
                        if unitModel.unitID == unitId {
                            self.currentUnitIndex = index + 1
                        }
                    }
                }

                self.loadSubViews()
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 学习新单元
    private func learnUnit(_ unitId: Int) {
        guard let uuidStr = YXConfigure.shared().uuid, let bookId = self.bookId else {
            return
        }
        let request = YXExerciseRequest.addUserBook(userId: uuidStr, bookId: bookId, unitId: unitId)
        YYNetworkService.default.request(YYStructResponse<YXLearnResultModel>.self, request: request, success: { (response) in
            YXLog("学习新单元成功")
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: Event
    @objc private func backClick() {
//        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc private func punchEvent() {
        guard let model = self.model else {
            YXUtils.showHUD(kWindow, title: "数据请求失败，请稍后再试～")
            return
        }
        let shareVC = YXShareViewController()
        
        if shareFinished {
            shareVC.hideCoin = true
        } else {
            shareVC.hideCoin = !model.isShowCoin
        }
        
        shareVC.shareType   = .learnResult
        shareVC.wordsAmount = model.allWordCount
        shareVC.daysAmount  = model.studyDay
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(shareVC, animated: true)
    }

    // MARK: ---- Notification ----
    @objc private func shareResult(notification: Notification) {
        guard let dict = notification.userInfo as? [String:AnyHashable], let isFinised = dict["isFinished"] as? Bool else {
            return
        }
        self.shareFinished = isFinised
    }
}
