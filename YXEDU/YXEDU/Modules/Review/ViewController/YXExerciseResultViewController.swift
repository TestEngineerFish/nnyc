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
    var unitMapView: YXUnitMapView?
    var shareFinished = false
    var loadingView   = YXExerciseResultLoadingView()
    
    deinit {
        resultView?.removeFromSuperview()
        unitMapView?.removeFromSuperview()
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
    }
    
    private func createSubviews() {
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(kSafeBottomMargin + 123))
            make.centerX.width.equalToSuperview()
            make.height.equalTo(AS(117))
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
        resultView?.snp.makeConstraints { (make) in
            make.top.equalTo(AS(68 + kSafeBottomMargin))
            make.left.right.equalToSuperview()
            make.height.equalTo(resultView?.viewHeight() ?? 0)
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
        
        let vc = YXExerciseViewController()
        vc.dataType = model?.type ?? .aiReview
        vc.planId = model?.id ?? 0
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
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
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    private func shareEvent() {
        let shareVC = YXShareViewController()
        shareVC.finishAction = { [weak self] in
            self?.shareFinished = true
        }
        
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
                self.initUnitMap()
            } else {
                UIView.toast("请求数据失败")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    // MAKE: ---- Event ----
    private func initUnitMap() {
        guard let resultView = self.resultView else {return}
        let mapSize = CGSize(width: AdaptSize(333), height: AdaptSize(192))
        let unitMapView = YXUnitMapView(totalUnit: 13, currentUnit: 9, frame: CGRect(origin: .zero, size: mapSize))
        self.view.addSubview(unitMapView)
        unitMapView.snp.makeConstraints { (make) in
            make.size.equalTo(mapSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(resultView.snp.bottom).offset(AdaptSize(10))
        }
        let leftBarImageView  = UIImageView(image: UIImage(named: "linkBar"))
        let rightBarImageView = UIImageView(image: UIImage(named: "linkBar"))
        self.view.addSubview(leftBarImageView)
        self.view.addSubview(rightBarImageView)
        leftBarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(resultView.snp.bottom).offset(AdaptSize(-15))
            make.left.equalTo(unitMapView).offset(AdaptSize(13))
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(41)))
        }
        rightBarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(leftBarImageView)
            make.right.equalTo(unitMapView).offset(AdaptSize(-13))
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(41)))
        }
    }
}
