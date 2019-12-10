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
}

extension YXReviewRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reviewBookList, .reviewWordList:
            return .get
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
        }
    }
}


