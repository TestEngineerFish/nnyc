//
//  YXChallengeRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/13.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

public enum YXChallengeRequest: YYBaseRequest {
    case challengeModel(flag: String)
    case playGame
}

extension YXChallengeRequest {
    var method: YYHTTPMethod {
        switch self {
        case .challengeModel, .playGame:
            return .get
        }
    }
}

extension YXChallengeRequest {
    var path: String {
        switch self {
        case .challengeModel:
            return YXAPI.Challenge.challengeModel
        case .playGame:
            return YXAPI.Challenge.playGame
        }
    }
}

extension YXChallengeRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .challengeModel(let flag):
            return ["gameId": 1, "flag":flag]
        case .playGame:
            return ["gameId": 1]
        }
    }
}
