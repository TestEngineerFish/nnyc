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
    
    
    
}
