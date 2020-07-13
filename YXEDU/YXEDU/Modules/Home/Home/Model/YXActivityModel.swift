//
//  YXActivityModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXActivityModel: Mappable {
    var isAction: Bool     = false
    var title: String      = ""
    var hadNewFriend: Bool = false
    var hadReward: Bool    = false

    init?(map: Map) {}
    mutating func mapping(map: Map) {
        isAction     <- map["status"]
        title        <- map["title"]
        hadNewFriend <- map["had_new_friend"]
        hadReward    <- map["had_reward"]
    }


}
