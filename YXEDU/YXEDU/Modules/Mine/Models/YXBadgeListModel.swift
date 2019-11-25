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
    var name: String?
    var description: String?
    var imageOfCompletedStatus: String?
    var imageOfIncompletedStatus: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        ID <- map["badgeId"]
        name <- map["badgeName"]
        description <- map["desc"]
        imageOfCompletedStatus <- map["realize"]
        imageOfIncompletedStatus <- map["unRealized"]
    }
}
