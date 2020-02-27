//
//  YXFeedbackData.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/26.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXFeedbackRequest: YYBaseRequest {
    case feedbackReply
    case reporyReply(ids: [Int])
}

extension YXFeedbackRequest {
    var method: YYHTTPMethod {
        switch self {
        case .reporyReply:
            return .post
        case .feedbackReply:
            return .get
        }
    }
}

extension YXFeedbackRequest {
    var path: String {
        switch self {
        case .reporyReply:
            return YXAPI.Other.feedbackReport
        case .feedbackReply:
            return YXAPI.Badge.feedbackReply
        }
    }
}

extension YXFeedbackRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .reporyReply(let ids):
            return ["feed_ids": ids]
        default:
            return nil
        }
    }
}
