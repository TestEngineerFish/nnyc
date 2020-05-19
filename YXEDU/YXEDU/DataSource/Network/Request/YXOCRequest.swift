//
//  YXOCRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXOCRequest: YYBaseRequest {
    case calendar

    public var method: YYHTTPMethod {
        switch self {
        case .calendar:
            return .get
        }
    }

    public var path: String {
        switch self {
        case .calendar:
            return YXAPI.OC.getMonthly2
        }
    }

    public var parameters: [String : Any?]? {
        switch self {
        case .calendar:
            return nil
        }
    }
}
