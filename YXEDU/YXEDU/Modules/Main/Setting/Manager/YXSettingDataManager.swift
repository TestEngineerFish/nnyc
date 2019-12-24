//
//  YXSettingDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


struct YXSettingDataManager {
    
    func checkVersion(completion: ((_ model: YXVersionModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXSettingRequest.checkVersion
        YYNetworkService.default.request(YYStructResponse<YXVersionModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            completion?(nil, error.message)
        }
    }
    
    
    func checkCommand(command: String, completion: ((_ model: YXReviewPlanCommandModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXSettingRequest.checkCommand(command: command)
        YYNetworkService.default.request(YYStructResponse<YXReviewPlanCommandModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            completion?(nil, error.message)
        }
    }
    
}