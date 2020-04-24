//
//  YXCalendarModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/24.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXCalendarModel: Mappable {

    var studyModel: [YXCalendarStudyModel] = []
    var summaryModel: YXCalendarSummaryModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.studyModel   <- map["study_detail"]
        self.summaryModel <- map["summary"]
    }
}

struct YXCalendarStudyModel: Mappable {
    var time: Int?
    var status: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.time   <- map["date"]
        self.status <- map["status"]
    }
}

struct YXCalendarSummaryModel: Mappable {
    var days: Int     = 0
    var words: Int    = 0
    var duration: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.days     <- map["study_days"]
        self.words    <- map["study_words"]
        self.duration <- map["study_duration"]
    }
}
