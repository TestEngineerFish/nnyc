//
//  YXShareRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


public enum YXShareRequest: YYBaseRequest {
    case punch
}

extension YXShareRequest {
    var method: YYHTTPMethod {
        switch self {
        case .punch:
            return .post
        }
    }
}

extension YXShareRequest {
    var path: String {
        switch self {
        case .punch:
            return YXAPI.Share.punch
        }
    }
}
