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
}

extension YXSettingRequest {
 var method: YYHTTPMethod {
     switch self {
     case .checkVersion, .checkCommand:
         return .get
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
        }
    }
}

extension YXSettingRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .checkCommand(let command):
            return ["code" : command]
        default:
        return nil
        }
    }
}
