//
//  YXWordListRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/10/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXWordListRequest: YYBaseRequest {
    case wordList(type: Int)
    case wrongWordList
}

extension YXWordListRequest {
    var method: YYHTTPMethod {
        switch self {
        case .wordList, .wrongWordList:
            return .get
        }
    }
}

extension YXWordListRequest {
    var path: String {
        switch self {
        case .wordList:
            return YXAPI.WordList.wordList
            
        case .wrongWordList:
            return YXAPI.WordList.wrongWordList
        }
    }
}

extension YXWordListRequest {
    var parameters: [String : Any]? {
        switch self {
        case .wordList(let type):
            return ["type" : type]
            
        default:
            return nil
        }
    }
}
