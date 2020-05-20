//
//  YXCalendarRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/24.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXCalendarRequest: YYBaseRequest  {
    case getMonthly(time: Int)

    var method: YYHTTPMethod {
        switch self {
        case .getMonthly:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getMonthly:
            return YXAPI.Calendar.getMonthly
        }
    }

    var parameters: [String : Any?]? {
        switch self {
        case .getMonthly(let time):
            return ["time":time]
        }
    }
}
