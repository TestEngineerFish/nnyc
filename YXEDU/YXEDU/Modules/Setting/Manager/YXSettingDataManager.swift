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
//            YXUtils.showHUD(nil, title: error.message)
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
    
    func fetchShareCommand(planId: Int, completion: ((_ model: YXReviewPlanShareCommandModel?, _ errorMsg: String?) -> Void)?) {
        let request = YXSettingRequest.shareCommand(plandId: planId)
        YYNetworkService.default.request(YYStructResponse<YXReviewPlanShareCommandModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
            completion?(nil, error.message)
        }
    }
    
    func reportOldUserTips(completion: ((_ model: YXBadgeReportModel?, _ errorMsg: String?) -> Void)?) {
        let data = "{\"old_user_update_msg\" : 1}"
        let request = YXSettingRequest.oldUserReport(data: data)
        YYNetworkService.default.request(YYStructResponse<YXBadgeReportModel>.self, request: request, success: { (response) in
            completion?(response.data, nil)
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
            completion?(nil, error.message)
        }
    }
    
}
