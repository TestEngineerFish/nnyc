//
//  YXMyClassRequestManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/23.
//  Copyright © 2020 shiji. All rights reserved.
//


import Foundation

public enum YXMyClassRequestManager: YYBaseRequest {
    case workList
    case classList
}

extension YXMyClassRequestManager {
    var method: YYHTTPMethod {
        switch self {
        case .workList, .classList:
            return .get
        }
    }
}

extension YXMyClassRequestManager {
    var path: String {
        switch self {
        case .workList:
            return YXAPI.MyClass.workList
        case .classList:
            return YXAPI.MyClass.classList
        }
    }
}

extension YXMyClassRequestManager {
    var parameters: [String : Any?]? {
        switch self {
        default:
            return nil
        }
    }
}
