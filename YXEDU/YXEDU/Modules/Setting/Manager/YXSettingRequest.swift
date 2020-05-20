//
//  YXSettingManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


public enum YXSettingRequest: YYBaseRequest {
    case checkVersion
    case checkCommand(command: String)
    case shareCommand(plandId: Int)
    case oldUserReport(data: String)
}

extension YXSettingRequest {
 var method: YYHTTPMethod {
     switch self {
     case .checkVersion:
         return .get
     case .oldUserReport, .checkCommand, .shareCommand:
        return .post
     }
 }
}

extension YXSettingRequest {
    var path: String {
        switch self {
        case .checkVersion:
            return YXAPI.Setting.checkVersion
        case .checkCommand:
            return YXAPI.Review.checkCommand
        case .shareCommand:
                return YXAPI.Review.shareCommand
        case .oldUserReport:
            return YXAPI.Setting.oldUserReport
        }
    }
}

extension YXSettingRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .checkCommand(let command):
            return ["code" : command]
        case .shareCommand(let planId):
                return ["review_plan_id" : planId]
        case .oldUserReport(let data):
            return ["data" : data]
        default:
        return nil
        }
    }
}
