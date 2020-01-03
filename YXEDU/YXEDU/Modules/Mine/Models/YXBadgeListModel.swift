//
//  YXBadgeListModel.swift
//  YXEDU
//
//  Created by Jake To on 11/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXBadgeListModel: Mappable {
    var title: String?
    var type: Int?
    var badges: [YXBadgeModel]?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        type <- map["type"]
        badges <- map["options"]
    }
}

struct YXBadgeModel: Mappable {
    var ID: Int?
    var badgeId: Int?
    var name: String?
    var description: String?
    var finishDateTimeInterval: Double?
    var currentProgress: Int?
    var totalProgress: Int?
    var imageOfCompletedStatus: String?
    var imageOfIncompletedStatus: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        ID <- map["badge_id"]
        badgeId <- map["user_badge_id"]
        name <- map["name"]
        description <- map["desc"]
        finishDateTimeInterval <- map["finish_time"]
        currentProgress <- map["done"]
        totalProgress <- map["total"]
        imageOfCompletedStatus <- map["realize"]
        imageOfIncompletedStatus <- map["un_realized"]
        
    }
}


struct YXBadgeReportModel: Mappable {
    var state: Int?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        state <- map["state"]
    }
}

