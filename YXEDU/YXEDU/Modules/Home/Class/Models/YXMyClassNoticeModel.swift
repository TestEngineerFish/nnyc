//
//  YXMyClassNoticeModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXMyClassNoticeModel: Mappable {
    var isNew: Bool     = false
    var content: String = ""
    var time: String    = ""

    init() {}
    init?(map: Map) {}

    func mapping(map: Map) {
        
    }
}
