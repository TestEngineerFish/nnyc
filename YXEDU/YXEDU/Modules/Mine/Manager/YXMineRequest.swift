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
    case getUserInfo
    case getCreditsInfo
    case updateSchoolInfo(schoolId: Int, cityId: Int, schoolName: String)
}

extension YXMineRequest {
    var method: YYHTTPMethod {
        switch self {
        case .badgeList, .latestBadge, .getUserInfo, .getCreditsInfo:
            return .get
        case .badgeDisplayReport, .updateSchoolInfo:
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
        case .getUserInfo:
            return YXAPI.User.getInfo
        case .getCreditsInfo:
            return YXAPI.User.getCreditsInfo
        case .updateSchoolInfo:
            return YXAPI.Profile.updateSchoolInfo
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .badgeDisplayReport(let badgeId):
            return ["user_badge_id" : badgeId]
        case .updateSchoolInfo(let schoolId, let cityId, let schoolName):
            return ["yx_school_id" : schoolId, "yx_city_id" : cityId, "yx_school_name" : schoolName]
        default:
            return nil
        }
    }
}
