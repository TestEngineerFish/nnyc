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
    case task
    case setReminder(dataString: String)
    case joinClass(classCode: String, workCode: String)
    case activityInfo
    case addFriend(id: Int, channel: Int)

    var method: YYHTTPMethod {
        switch self {
        case .report, .task, .getBaseInfo, .getBookList, .joinClass, .activityInfo, .addFriend:
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
        case .task:
            return YXAPI.Home.task
        case .setReminder:
            return YXAPI.Home.setReminder
        case .joinClass:
            return YXAPI.Home.joinClass
        case .activityInfo:
            return YXAPI.Home.activityInfo
        case .addFriend:
            return YXAPI.Home.addFriend
        }
    }

    var parameters: [String : Any?]? {
        switch self {
        case .getBaseInfo(let userId):
            return ["user_id": userId]
        case .setReminder(let dataString):
            return ["data": dataString]
        case .joinClass(let classCode, let workCode):
            return ["class_code" : classCode, "work_code" : workCode]
        case .addFriend(let id, let channel):
            return ["friend_id" : id, "channel" : channel]
        default:
            return nil
        }
    }
}
