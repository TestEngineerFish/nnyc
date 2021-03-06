//
//  YXChallengeModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

struct YXChallengeUnlockModel: Mappable {

    var state: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        state <- map["state"]
    }
}

struct YXChallengeModel: Mappable {

    var bannerModel: YXChallengeBanner?
    var gameInfo: YXChallengeGameInfo?
    var userModel: YXChallengeUserModel?
    var rankedList: [YXChallengeUserModel] = [] // 排行榜数据列表
    var title = ""

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        bannerModel <- map["banners"]
        gameInfo    <- map["game_info"]
        userModel   <- map["user_info"]
        rankedList  <- map["list"]
        title       <- map["title"]
    }
}

struct YXChallengeBanner: Mappable {

    var imageUrl: String = ""
    var redirect: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        imageUrl <- map["img_url"]
        redirect <- map["redirect"]
    }
}

struct YXChallengeGameInfo: Mappable {

    var unitCoin: Int     = 0
    var unlockCoin: Int   = 0
    var timeLeft: Int     = 0
    var lastRanking: Bool = false
    var gameLinedId: Int  = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        unitCoin    <- map["pre_coin"]
        unlockCoin  <- map["unlock_coin"]
        timeLeft    <- map["end_time"]
        lastRanking <- map["last_ranking"]
        gameLinedId <- map["game_lined_id"]
    }
}

enum YXChallengeResultType: Int {
    case success    = 1 // 有挑战、有排名
    case fail       = 2 // 有挑战、无排名(未作答)
    case unanswered = 3 // 未挑战、无排名
}

struct YXChallengeUserModel: Mappable {

    var ranking: Int       = 0
    var name: String       = ""
    var avatarStr: String  = ""
    var time: Float        = 0 // 毫秒单位
    var questionCount: Int = 0
    var bonus: Int         = 0
    // ---- 当前用户独有字段 ----
    var gameStatus: YXChallengeStatusType      = .lock
    var challengeResult: YXChallengeResultType = .unanswered
    var myCoins: Int             = 0
    var isShowed: Bool           = true
    var previousRankVersion: Int = 0


    init?(map: Map) { }

    mutating func mapping(map: Map) {
        ranking         <- map["ranking"]
        name            <- map["nick"]
        avatarStr       <- map["avatar"]
        time            <- map["speed_time"]
        questionCount   <- map["correct_num"]
        bonus           <- map["bonus"]
        challengeResult <- map["state"]
        gameStatus      <- map["status"]
        myCoins         <- map["credits"]
        isShowed        <- map["last_show_code"]
        previousRankVersion <- map["last_game_lined_id"]
    }
}
