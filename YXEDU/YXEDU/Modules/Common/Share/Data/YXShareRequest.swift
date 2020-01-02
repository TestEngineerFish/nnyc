//
//  YXShareRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


public enum YXShareRequest: YYBaseRequest {
    case punch(type: Int) // 1 分享到qq 2 分享到微信好友 3分享到朋友圈

    var method: YYHTTPMethod {
        switch self {
        case .punch:
            return .post
        }
    }

    var path: String {
        switch self {
        case .punch:
            return YXAPI.Share.punch
        }
    }

    public var parameters: [String : Any?]? {
        switch self {
        case .punch(let type):
            return ["type" : type]
        }
    }
}


