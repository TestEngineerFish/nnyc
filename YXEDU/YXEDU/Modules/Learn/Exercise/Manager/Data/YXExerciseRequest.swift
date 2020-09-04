//
//  YXExerciseRequest.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXExerciseRequest: YYBaseRequest {
    case exercise(isGenerate: Bool, type: Int, reviewId: Int?)
    case learnMap(bookId: Int)
    case learnResult(bookId: Int, unitId: Int, wordId: Int)
    case report(type: Int, reviewId: Int, time: Int, result: String, bookId: Int)
    case addUserBook(userId: String, bookId: Int, unitId: Int)
    case reportListenScore(wordId: Int, score: Int)
    case stepConfig
    case learnShare(shareType: Int, learnType: Int)
}


extension YXExerciseRequest {
    var method: YYHTTPMethod {
        switch self {
        case .exercise, .learnMap, .learnResult, .addUserBook, .stepConfig:
            return .get
        case .report, .reportListenScore, .learnShare:
            return .post
        }
    }

    var path: String {
        switch self {
        case .exercise:
            return YXAPI.Exercise.exercise
        case .learnMap:
            return YXAPI.Exercise.learnMap
        case .learnResult:
            return YXAPI.Exercise.learnResult
        case .report:
            return YXAPI.Exercise.report
        case .addUserBook:
            return YXAPI.Word.addUserBook
        case .reportListenScore:
            return YXAPI.Exercise.reportListenScore
        case .stepConfig:
            return YXAPI.Exercise.stepConfig
        case .learnShare:
            return YXAPI.Exercise.learnShare
        }
    }

    var parameters: [String : Any?]? {
        switch self {
        case.exercise(let isGenerate, let type, let planId):
            return ["is_generate" : isGenerate, "learn_type" : type, "review_id" : planId]
        case .learnMap(let bookId):
            return ["book_id" : bookId]
        case .learnResult(let bookId, let unitId, let workId):
            return ["book_id" : bookId, "unit_id" : unitId, "work_id" : workId]
        case .addUserBook(let userId, let bookId, let unitId):
            return ["user_id":userId, "book_id":bookId, "unit_id":unitId]
        case .report(let type, let reviewId, let time, let result, let bookId):
            return ["learn_type" : type, "cost_time" : time, "learn_result" : result, "review_id" : reviewId, "book_id" : bookId]
        case .reportListenScore(let wordId, let score):
            return ["word_id" : wordId, "listen_score" : score]
        case .learnShare(let shareType, let learnType):
            return ["type" : shareType, "learn_type" : learnType]
        default:
            return nil
        }
    }
    

    var isHttpBody: Bool {
        switch self {
//        case .report: return true
        default: return false
        }
    }

}
