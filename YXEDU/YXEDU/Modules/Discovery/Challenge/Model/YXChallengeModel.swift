//
//  YXChallengeModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper


struct YXChallengeModel: Mappable {

    var time: Int      = 0 //活动剩余时间
    var unitPrice: Int = 0 //参与一次费用
    var lockPrice: Int = 0 //活动解锁费用
    var ruleUrl: String?   //活动规则地址
    var status: YXChallengeStatusType = .normal
    var userCoins: Int = 0 //用户剩余金币
    var backgroundImageUrl: String? //活动背景图地址
    var rankedList: [YXChallengeUserModel] = [] // 排行榜数据列表

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        time      <- map[""]
        unitPrice <- map[""]
        lockPrice <- map[""]
        ruleUrl   <- map[""]
        backgroundImageUrl <- map[""]

    }
}

struct YXChallengeUserModel: Mappable {

    var rank: Int?
    var name: String = ""
    var avatarStr: String = ""
    var time: Int = 0
    var questionCount: Int = 0


    init?(map: Map) { }

    mutating func mapping(map: Map) {

    }


}
