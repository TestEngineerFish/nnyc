//
//  YXFeedbackModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXFeedbackModel: Mappable {
    
    var id: Int?
    var time: Double?
    var isNew: Bool = false
    var content: String?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map[""]
        time    <- map[""]
        isNew   <- map[""]
        content <- map[""]
    }
    
    
}
