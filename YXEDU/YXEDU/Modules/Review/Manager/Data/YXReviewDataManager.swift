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
            completion?(nil, error.message)
        }
    }
    
    
    func fetchReviewPlanDetailData(planId: Int, completion: ((_ model: YXReviewPlanDetailModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.reviewPlanDetail(planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXReviewPlanDetailModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            completion?(nil, error.message)
        }
    }
    
    
    /// 上报复习结果
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - planId: <#planId description#>
    ///   - completion: <#completion description#>
    func fetchReviewResult(type: YXExerciseDataType, planId: Int?, completion: ((_ model: YXReviewResultModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXReviewRequest.reviewResult(type: type.rawValue, planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXReviewResultModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            completion?(nil, error.message)
        }
    }
}
