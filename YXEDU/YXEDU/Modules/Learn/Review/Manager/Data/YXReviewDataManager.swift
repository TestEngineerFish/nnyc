//
//  YXReviewDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/16.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXReviewDataManager {
    
    func fetchReviewPlanData(completion: ((_ model: YXReviewPageModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.reviewPlan
        YYNetworkService.default.request(YYStructResponse<YXReviewPageModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, error.message)
        }
    }
    
    func updateReviewPlanName(planId: Int, planName: String, completion: ((_ result: Bool?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.updateReviewPlan(planId: planId, planName: planName)
        YYNetworkService.default.request(YYStructResponse<YXReviewPageModel>.self, request: request, success: { (response) in
            completion?(true, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, error.message)
        }
    }
    
    func removeReviewPlan(planId: Int, completion: ((_ result: Bool?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.removeReviewPlan(planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXReviewPageModel>.self, request: request, success: { (response) in
            completion?(true, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, error.message)
        }
    }
    
    
    func fetchReviewPlanDetailData(planId: Int, completion: ((_ model: YXReviewPlanDetailModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.reviewPlanDetail(planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXReviewPlanDetailModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, error.message)
        }
    }

    func resetReviewPlanData(planId: Int, completion: ((Bool)->Void)?) {
        let request = YXReviewRequest.resetReviewPlan(planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXResetReviewPlanModel>.self, request: request, success: { (response) in
            guard let resetReviewPlanModel = response.data, resetReviewPlanModel.isSuccess == 1 else {
                return
            }
            completion?(resetReviewPlanModel.isSuccess == 1)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
             completion?(false)
        }
    }
    
    
    /// 上报复习结果
    /// - Parameters:
    ///   - type:
    ///   - planId:
    ///   - completion:
    func fetchReviewResult(type: YXLearnType, reviewId: Int, completion: ((_ model: YXReviewResultModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.reviewResult(type: type.rawValue, reviewId: reviewId)
        YYNetworkService.default.request(YYStructResponse<YXReviewResultModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, error.message)
        }
    }
}
