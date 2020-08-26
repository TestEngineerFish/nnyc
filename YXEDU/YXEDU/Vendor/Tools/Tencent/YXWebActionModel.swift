//
//  YXWebActionModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXWXWebModel: Mappable {

    var action: String = ""
    var scheme: String = ""
    var params: String = ""
    var channel: Int   = 0
    var name: String = ""
    var teacherName: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        action      <- map["open_app_action"]
        scheme      <- map["open_app_scheme"]
        params      <- map["action_params"]
        channel     <- map["channel"]
        name        <- map["name"]
        teacherName <- map["teacher_name"]
    }
}

