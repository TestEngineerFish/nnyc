//
//  YXSearchRequest.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXSearchRequest: YYBaseRequest {
    case search(keyword: String)
}

extension YXSearchRequest {
    var method: YYHTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
}

extension YXSearchRequest {
    var path: String {
        switch self {
        case .search:
            return YXAPI.Word.searchWord
        }
    }
}

extension YXSearchRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .search(let keyword):
            return ["word" : keyword]
        }
    }
}


