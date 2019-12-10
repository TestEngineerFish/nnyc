//
//  YXExerciseRequest.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXExerciseRequest: YYBaseRequest {
    case exercise
    case learnMap(bookId: Int)
    case learnResult(bookId: Int, unitId: Int)
    case report(json: String)
    case addUserBook(userId: String, bookId: Int, unitId: Int)
}


extension YXExerciseRequest {
    var method: YYHTTPMethod {
        switch self {
        case .exercise, .learnMap, .learnResult, .addUserBook:
            return .get
        case .report:
            return .post
        }
    }

    var path: String {
        switch self {
        case .exercise:
            return YXAPI.Word.exercise
        case .learnMap:
            return YXAPI.Word.learnMap
        case .learnResult:
            return YXAPI.Word.learnResult
        case .report:
            return YXAPI.Word.report
        case .addUserBook:
            return YXAPI.Word.addUserBook
        }
    }

    var parameters: [String : Any?]? {
        switch self {
        case .learnMap(let bookId):
            return ["book_id" : bookId]
        case .learnResult(let bookId, let unitId):
            return ["book_id" : bookId, "unit_id" : unitId]
        case .addUserBook(let userId, let bookId, let unitId):
            return ["user_id":userId, "book_id":bookId, "unit_id":unitId]
        case .report(let json):
            return ["json" : json]
        default:
            return nil
        }
    }
    

    var isHttpBody: Bool {
        switch self {
        case .report: return true
        default: return false
        }
    }

}
