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

    var method: YYHTTPMethod {
        switch self {
        case .report:
            return .get
        }
    }

    var path: String {
        switch self {
        case .report:
            return YXAPI.Home.report
        }
    }
}
