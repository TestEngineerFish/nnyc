//
//  YXWordBookRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXWordBookRequest: YYBaseRequest {
    case downloadWordBook(bookId: Int?)
    case addWordBook(userId: String, bookId: Int, unitId: Int)

    var method: YYHTTPMethod {
        switch self {
        case .downloadWordBook, .addWordBook:
            return .get
        }
    }

    var path: String {
        switch self {
        case .downloadWordBook:
            return YXAPI.Word.downloadWordBook
            
        case .addWordBook:
            return YXAPI.Word.addUserBook
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .downloadWordBook(let bookId):
            if let bookId = bookId {
                return ["book_id": bookId]
                
            } else {
                return nil
            }
            
        case .addWordBook(let userId, let bookId, let unitId):
            return ["user_id": userId, "book_id": bookId, "unit_id": unitId]
        }
    }
}
