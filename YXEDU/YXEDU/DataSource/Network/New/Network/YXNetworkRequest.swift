//
//  YXNetworkRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXNetworkRequest: YYBaseRequest {
    case renewal

    public var method: YYHTTPMethod {
        switch self {
        case .renewal:
            return .get
        }
    }

    public var path: String {
        switch self {
        case .renewal:
            return YXAPI.Network.tokenRenewal
        }
    }

}
