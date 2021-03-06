//
//  YXFeedbackReplyModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXFeedbackReplyModel: Mappable {
    
    var id: Int?
    var dateStr: String?
    var isRead: Bool = false
    var content: String?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id      <- map["feed_id"]
        dateStr <- map["reply_date"]
        isRead  <- map["reply_state"]
        content <- map["reply_content"]
    }
    
    
}
