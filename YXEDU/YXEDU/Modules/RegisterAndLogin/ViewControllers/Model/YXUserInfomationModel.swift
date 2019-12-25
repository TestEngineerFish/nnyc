//
//  YXUserInfomationModel.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXUserInfomationModel: Mappable {
    var didBindPhone: Int?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        didBindPhone <- map["is_bind_mobile"]
    }
}
