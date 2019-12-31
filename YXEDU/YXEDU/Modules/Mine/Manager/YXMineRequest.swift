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
    case badgeDisplayReport(badgeId: Int)
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
    
    var parameters: [String : Any?]? {
        switch self {
        case .badgeDisplayReport(let badgeId):
            return ["user_badge_id" : badgeId]
        default:
            return nil
        }
    }
}
