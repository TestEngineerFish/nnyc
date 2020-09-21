//
//  YXMyClassNoticeModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXMyClassNoticeListModel: Mappable {
    var hasMore: Bool = false
    var list: [YXMyClassNoticeModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.hasMore  <- map["has_more"]
        self.list     <- map["list"]
    }
}

struct YXMyClassNoticeModel: Mappable {
    var isRead: Bool        = true
    var content: String     = ""
    var timeStr: String     = ""
    var teacherName: String = ""
    var className: String   = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.isRead      <- map["is_read"]
        self.content     <- map["content"]
        self.timeStr     <- map["created_at"]
        self.teacherName <- map["teacher_name"]
        self.className   <- map["class_name"]
    }
}
