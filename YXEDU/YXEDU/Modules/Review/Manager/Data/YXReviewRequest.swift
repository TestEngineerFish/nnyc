//
//  YXReviewRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

public enum YXReviewRequest: YYBaseRequest {
    case reviewBookList
}

extension YXReviewRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reviewBookList:
            return .get
        }
    }
}

extension YXReviewRequest {
    var path: String {
        switch self {
        case .reviewBookList:
            return YXAPI.Review.reviewBookList
        }
    }
}

extension YXReviewRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .reviewBookList:
            return nil
        }
    }
}


