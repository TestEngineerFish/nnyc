//
//  YXChallengeRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/13.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

public enum YXChallengeRequest: YYBaseRequest {
    case challengeModel(_ id: Int?, flag: String)
}

extension YXChallengeRequest {
    var method: YYHTTPMethod {
        switch self {
        case .challengeModel:
            return .get
        }
    }
}

extension YXChallengeRequest {
    var path: String {
        switch self {
        case .challengeModel:
            return YXAPI.Challenge.challengeModel
        }
    }
}

extension YXChallengeRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .challengeModel(let id, let flag):
            return ["gameId": id, "flag":flag]
        }
    }
}
