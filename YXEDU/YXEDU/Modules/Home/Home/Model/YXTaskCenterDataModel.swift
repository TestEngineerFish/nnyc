//
//  YXTaskCenterDailyDataModel.swift
//  YXEDU
//
//  Created by Jake To on 12/17/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXTaskCenterDataModel: Mappable {
    var integral: Int?
    var exIntegral: Int?
    var today: Int?
    var dailyData: [YXTaskCenterDailyDataModel]?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        today <- map["today"]
        integral <- map["user_credits"]
        exIntegral <- map["multiplier_score"]
        dailyData <- map["list"]
    }
}

struct YXTaskCenterDailyDataModel: Mappable {
    var weekName: String?
    var dailyStatus: YXTaskCenterDailyStatus = .today

    var weekDay: Int?
    var didPunchIn: Int?
    var integral: Int?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        weekDay <- map["week_day"]
        didPunchIn <- map["sign_in"]
        integral <- map["credit"]
    }
}

struct YXTaskCenterBadgeModel: Mappable {
    var num: Int = 0
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        num <- map["num"]
    }
}

enum YXTaskCenterDailyStatus {
    case yesterday
    case today
    case tomorrow
}
