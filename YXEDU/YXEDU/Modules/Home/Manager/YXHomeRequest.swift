//
//  YXWordBookRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXHomeRequest: YYBaseRequest {
    case getBaseInfo(userId: String)
    case getBookList
    case report
    case updateToken
    case task
    case setReminder(dataString: String)

    var method: YYHTTPMethod {
        switch self {
        case .report, .updateToken, .task, .getBaseInfo, .getBookList:
            return .get
            
        case .setReminder:
            return .post
        }
    }

    var path: String {
        switch self {
        case .getBaseInfo:
            return YXAPI.Home.getBaseInfo
            
        case .getBookList:
            return YXAPI.Home.getBookList

        case .report:
            return YXAPI.Home.report
        case .updateToken:
            return YXAPI.User.updateToken
        case .task:
            return YXAPI.Home.task
        case .setReminder:
            return YXAPI.Home.setReminder
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
            case .getBaseInfo(let userId):
            return ["user_id": userId]
            
        case .setReminder(let dataString):
            return ["data": dataString]
            
        default:
            return nil
        }
    }
}
