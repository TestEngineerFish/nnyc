//
//  YXMineRequest.swift
//  YXEDU
//
//  Created by Jake To on 11/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXMineRequest: YYBaseRequest {
    case badgeList
    case latestBadge
    case badgeDisplayReport
}

extension YXMineRequest {
    var method: YYHTTPMethod {
        switch self {
        case .badgeList, .latestBadge:
            return .get
        case .badgeDisplayReport:
            return .post
        }
    }
}

extension YXMineRequest {
    var path: String {
        switch self {
        case .badgeList:
            return YXAPI.Profile.badgeList
        case .latestBadge:
            return YXAPI.Profile.latestBadge
        case .badgeDisplayReport:
                return YXAPI.Profile.badgeDisplayReport
        }
    }
}
