//
//  YXWordBookRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXHomeRequest: YYBaseRequest {
    case report
    case updateToken
    case task

    var method: YYHTTPMethod {
        switch self {
        case .report, .updateToken, .task:
            return .get
        }
    }

    var path: String {
        switch self {
        case .report:
            return YXAPI.Home.report
        case .updateToken:
            return YXAPI.User.updateToken
        case .task:
            return YXAPI.Home.task
        }
    }
}
