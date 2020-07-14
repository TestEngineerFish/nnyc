//
//  YXActivityModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXActivityModel: Mappable {
    var isShow: Bool       = false
    var isAction: Bool     = false
    var taskFinished: Bool = false
    var isJoin: Bool       = false
    var title: String      = ""
    var hadNewFriend: Bool = false
    var hadReward: Bool    = false
    var punchAmount: Int   = 0
    var punchToday: Int    = 0
    var urlStr: String     = ""

    init?(map: Map) {}
    mutating func mapping(map: Map) {
        isAction     <- map["activity_status"]
        isShow       <- map["show_status"]
        taskFinished <- map["task_status"]
        title        <- map["title"]
        hadNewFriend <- map["had_new_friend"]
        hadReward    <- map["had_reward"]
        punchAmount  <- map["need_clock_num"]
        punchToday   <- map["today_clock_num"]
        urlStr       <- map["activity_url"]
        isJoin       <- map["join_status"]
    }


}
