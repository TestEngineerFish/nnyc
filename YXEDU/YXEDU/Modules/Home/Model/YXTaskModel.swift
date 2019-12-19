//
//  YXTaskModel.swift
//  YXEDU
//
//  Created by Jake To on 12/17/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXTaskListModel: Mappable {
    var typeName: String?
    var list: [YXTaskModel]?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        typeName <- map["type_name"]
        list <- map["list"]
    }
}

struct YXTaskModel: Mappable {
    var id: Int?
    var name: String?
    var taskType: Int?
    var actionType: Int?
    var integral: Int?
    var state: Int?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["task_id"]
        name <- map["task_name"]
        taskType <- map["type"]
        actionType <- map["action_code"]
        integral <- map["task_credit"]
        state <- map["state"]
    }
}
