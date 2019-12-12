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

    var time: Int      = 0
    var unitPrice: Int = 0
    var lockPrice: Int = 0
    var ruleUrl: String?
    var backgroundImageUrl: String?

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
