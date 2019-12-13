//
//  YXReviewRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

public enum YXReviewRequest: YYBaseRequest {
    case reviewBookList
    case reviewWordList(bookId: Int, bookType: Int)
    case makeReviewPlan(name: String, code: String?, idsList:String)
}

extension YXReviewRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reviewBookList, .reviewWordList:
            return .get
        case .makeReviewPlan:
            return .post
        }
    }
}

extension YXReviewRequest {
    var path: String {
        switch self {
        case .reviewBookList:
            return YXAPI.Review.reviewBookList
        case .reviewWordList:
            return YXAPI.Review.reviewWordList
        case .makeReviewPlan:
            return YXAPI.Review.maekReviewPlan
        }
    }
}

extension YXReviewRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .reviewBookList:
            return nil
        case .reviewWordList(let bookId, let bookType):
            return ["review_book_id" : bookId, "review_book_type" : bookType]
        case .makeReviewPlan(let name, let code, let idsList):
            return ["review_plan_name" : name, "review_share_code" : code, "review_word_ids" : idsList]
        }
    }
}


