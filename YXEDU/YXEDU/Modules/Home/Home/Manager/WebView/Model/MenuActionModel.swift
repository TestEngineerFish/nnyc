//
//  MenuActionModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct MenuActionModel: Mappable {

    var type: Int     = 2
    var event: String = ""

    init?(map: Map) {
        self.mapping(map: map)
    }

    mutating func mapping(map: Map) {
        type  <- map["type"]
        event <- map["event"]
    }
}
