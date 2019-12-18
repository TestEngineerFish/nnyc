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
    var todayEarnIntegral: Int?
    var punchInCount: Int?
    var dailyData: [YXTaskCenterDailyDataModel]?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        integral <- map["user_credits"]
        todayEarnIntegral <- map["multiplier_score"]
        dailyData <- map["list"]
    }
}

struct YXTaskCenterDailyDataModel: Mappable {
    var didPunchIn: Int?
    var integral: Int?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        didPunchIn <- map["sign_in"]
        integral <- map["credit"]
    }
}
