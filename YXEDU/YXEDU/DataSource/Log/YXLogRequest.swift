//
//  YXLogRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/16.
//  Copyright © 2020 shiji. All rights reserved.
//

public enum YXLogRequest: YYBaseRequest {
    case report(file: Data)

    public var method: YYHTTPMethod {
        switch self {
        case .report:
            return .post
        }
    }

    public var path: String {
        switch self {
        case .report:
            return YXAPI.Other.report
        }
    }

    public var parameters: [String : Any?]? {
        switch self {
        case .report(let file):
            return ["file" : file]
        }
    }
}
