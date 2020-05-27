//
//  YXExerciseResultViewController.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


/// 复习结果页（除基础学习外）
class YXExerciseResultViewController: YXViewController {
    
    var dataType: YXExerciseDataType = .planReview
    var planId: Int = 0
    
    var model: YXExerciseResultDisplayModel?
    var resultView: YXExerciseResultView?
    var shareFinished = false
    var loadingView   = YXExerciseResultLoadingView()
    
    deinit {
        resultView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchData()
        }
    }
    
    override func addNotification() {
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareResult(notification:)), name: YXNotification.kShareResult, object: nil)
    }
    
    private func createSubviews() {
        self.view.addSubview(loadingView)
        if let navBar = customNavigationBar {
            self.view.bringSubviewToFront(navBar)
        }
        loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(AdaptIconSize(123))
            make.centerX.width.equalToSuperview()
            make.height.equalTo(AdaptIconSize(117))
        }
    }
    
    private func initResultView() {
        self.loadingView.removeFromSuperview()

        self.resultView = YXExerciseResultView(model: model!)
        
        resultView?.processEvent = { [weak self] in
            self?.processEvent()
        }
        resultView?.showWordListEvent = { [weak self] in
            self?.showWordListEvent()
        }
        resultView?.reportEvent = { [weak self] in
            self?.reportPageEvent()
        }

        self.view.addSubview(resultView!)
        let resultH = (resultView?.viewHeight() ?? 0) + (isPad() ? AdaptSize(30) : 0)
        resultView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(isPad() ? 30 : 0))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(isPad() ? -150 : 0))
            make.height.equalTo(resultH)
        }
    }
    
    private func processEvent() {
        if model?.type == .wrong {
            YRRouter.popViewController(true)
        } else if model?.type == .base || (model?.state ?? false) {
            self.shareEvent()
        } else {
            self.reviewEvent()
        }
    }
    
    private func reviewEvent() {
        YRRouter.popViewController(false)
        
        let planId = model?.id ?? 0
        let learnType = model?.type ?? .aiReview
        let learnConfig = YXReviewLearnConfig(planId: planId, learnType: learnType)

        YXWordBookResourceManager.shared.contrastBookData()
        let vc = YXExerciseViewController()
        vc.learnConfig = learnConfig
        vc.hidesBottomBarWhenPushed = true
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    private func showWordListEvent() {
        let wrongWordListView = YXWrongWordsListView()
        let wordsList = model?.words ?? []
        wrongWordListView.bindData(wordsList)
        let h = wordsList.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }
    
    private func reportPageEvent() {
        let vc = YXReviewPlanReportViewController()
        vc.planId = model?.id ?? 0
        vc.reviewPlanName = model?.title ?? ""
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    private func shareEvent() {
        let shareVC = YXShareViewController()
        if shareFinished {
            shareVC.hideCoin = true
        } else {
            shareVC.hideCoin = !(model?.isShowCoin ?? false)
        }
        shareVC.shareType = shareType()
        shareVC.wordsAmount = model?.reviewWordNum ?? 0
        shareVC.daysAmount = model?.studyDay ?? 0
        self.navigationController?.pushViewController(shareVC, animated: true)
    }

    private func shareType() -> YXShareImageType {
        switch model?.type {
        case .base:
            return .learnResult
        case .aiReview:
            return .aiReviewReuslt
        case .planListenReview:
            return .listenReviewResult
        case .planReview:
            return .planReviewResult
        case .wrong:
            return .aiReviewReuslt
        default:
            return .aiReviewReuslt
        }
    }
    
    // MAKE: ---- Request ----
    
    func fetchData() {
        YXReviewDataManager().fetchReviewResult(type: dataType, planId: planId) { [weak self] (resultModel, error) in
            guard let self = self else {return}
            
            if var model = resultModel {                             
                model.planId = self.planId

                let m = YXExerciseResultDisplayModel.displayModel(model: model)
                self.model = m
                self.initResultView()
            } else {
                UIView.toast("请求数据失败")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }

    // MARK: ---- Notification ----
    @objc private func shareResult(notification: Notification) {
        guard let dict = notification.userInfo as? [String:AnyHashable], let isFinised = dict["isFinished"] as? Bool else {
            return
        }
        self.shareFinished = isFinised
    }
}
