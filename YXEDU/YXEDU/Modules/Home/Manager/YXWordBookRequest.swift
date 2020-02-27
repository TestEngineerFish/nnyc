//
//  YXWordBookRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXWordBookRequest: YYBaseRequest {
    case wordDetail(wordId: Int, isComplexWord: Int)
    case downloadWordBook(bookId: Int?)
    case addWordBook(userId: String, bookId: Int, unitId: Int)
    case getBookWord(bookId: Int)
    case bookList
    
    var method: YYHTTPMethod {
        switch self {
        case .wordDetail, .downloadWordBook, .addWordBook, .getBookWord, .bookList:
            return .get
        }
    }

    var path: String {
        switch self {
        case .wordDetail:
            return YXAPI.Word.wordDetail
        case .downloadWordBook:
            return YXAPI.Word.downloadWordBook
        case .addWordBook:
            return YXAPI.Word.addUserBook
        case .getBookWord:
            return YXAPI.Word.getBookWords
        case .bookList:
            return YXAPI.Word.bookList
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .wordDetail(let wordId, let isComplexWord):
            return ["word_id": wordId, "is_synthesis": isComplexWord]
        case .downloadWordBook(let bookId):
            if let bookId = bookId {
                return ["book_id": bookId]
            } else {
                return nil
            }
        case .addWordBook(let userId, let bookId, let unitId):
            return ["user_id": userId, "book_id": bookId, "unit_id": unitId]
        case .getBookWord(let bookId):
            return ["book_id" : bookId]
        default:
            return nil
        }
    }
}
