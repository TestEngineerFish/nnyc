//
//  YXWordBookRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXWordBookRequest: YYBaseRequest {
    case downloadWordBook(bookId: Int)
    
    var method: YYHTTPMethod {
        switch self {
        case .downloadWordBook:
            return .get
        }
    }

    var path: String {
        switch self {
        case .downloadWordBook:
            return YXAPI.Word.downloadWordBook
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .downloadWordBook(let bookId):
            return ["book_id": bookId]
        }
    }
}
