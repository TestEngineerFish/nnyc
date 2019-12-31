//
//  YXChallengeRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/13.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

public enum YXChallengeRequest: YYBaseRequest {
    case challengeModel
    case rankedList
    case playGame(gameId: Int)
    case report(version: Int, totalTime: Int, number: Int)
    case unlock
}

extension YXChallengeRequest {
    var method: YYHTTPMethod {
        switch self {
        case .challengeModel, .playGame, .rankedList:
            return .get
        case .report, .unlock:
            return .post
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
        case .report:
            return YXAPI.Challenge.gameReport
        case .rankedList:
            return YXAPI.Challenge.rankedList
        case .unlock:
            return YXAPI.Challenge.unlock
        }
    }
}

extension YXChallengeRequest {
    public var parameters: [String : Any?]? {
        switch self {
        case .challengeModel:
            return ["game_id": 1]
        case .playGame(let gameId):
            return ["game_lined_id": gameId]
        case .report(let version, let totalTime, let number):
            return ["game_lined_id": version, "total_time" : totalTime, "num" : number]
        case .rankedList:
            return ["game_id": 1, "flag" : "pre"]
        case .unlock:
            return ["game_id": 1]
        }
    }
}
