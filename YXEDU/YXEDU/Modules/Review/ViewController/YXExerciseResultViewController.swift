//
//  YXExerciseResultViewController.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseResultViewController: YXViewController {

    var model: YXExerciseResultDisplayModel!
    var resultView: YXExerciseResultView!
//    var
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
        
        self.view.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        let vc = YXExerciseViewController()
        vc.dataType = model?.type ?? .aiReview
        vc.planId = model.id
        YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
    }
    
    
    private func shareEvent() {
        let shareVC = YXShareViewController()
        shareVC.shareType = shareType()
        shareVC.wordsAmount = model?.allWordNum ?? 0
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
