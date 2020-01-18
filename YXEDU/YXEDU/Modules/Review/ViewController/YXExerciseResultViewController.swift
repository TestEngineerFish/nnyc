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

    var model: YXExerciseResultDisplayModel!
    var resultView: YXExerciseResultView!
    var shareFinished = false
    
    deinit {
        resultView.removeFromSuperview()
    }
    
    
    init(model: YXExerciseResultDisplayModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        resultView = YXExerciseResultView(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
        NotificationCenter.default.post(name: YXNotification.kRefreshReviewDetailPage, object: nil)
                
        resultView.processEvent = { [weak self] in
            self?.processEvent()
        }
        resultView.showWordListEvent = { [weak self] in
            self?.showWordListEvent()
        }
        
        self.view.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(68 + kSafeBottomMargin))
            make.left.right.equalToSuperview()
            make.height.equalTo(resultView.viewHeight())
        }
    }
    
    
    private func processEvent() {
        if model.type == .wrong {
            YRRouter.popViewController(true)
        } else if model.type == .base || model.state {
            self.shareEvent()
        } else {
            self.reviewEvent()
        }
    }
    
    private func reviewEvent() {
        YRRouter.popViewController(false)
        
        let vc = YXExerciseViewController()
        vc.dataType = model?.type ?? .aiReview
        vc.planId = model.id
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    private func showWordListEvent() {
        let wrongWordListView = YXWrongWordsListView()
        let wordsList = model.words ?? []
        wrongWordListView.bindData(wordsList)
        let h = wordsList.count > 3 ? AdaptSize(367) : AdaptSize(170)
        YXAlertCustomView.share.show(wrongWordListView, h: h)
    }
    
    private func shareEvent() {
        let shareVC = YXShareViewController()
        shareVC.finishAction = { [weak self] in
            self?.shareFinished = true
        }
        
        if shareFinished {
            shareVC.hideCoin = true
        } else {
            shareVC.hideCoin = !model.isShowCoin
        }
        
        shareVC.shareType = shareType()
        shareVC.wordsAmount = model?.reviewWordNum ?? 0
        shareVC.daysAmount = model?.studyDay ?? 0
    
        
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(shareVC, animated: true)
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
}
