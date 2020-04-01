//
//  JSBridgeModel.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/18.
//  Copyright © 2020 yx. All rights reserved.
//

import ObjectMapper

struct JSBridgeModel: Mappable {
    
    
//    NSString *action = messageBody[@"action"];
//    NSString *callback = messageBody[@"callback"];
//    NSDictionary *params = messageBody[@"params"];
    var token: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
    }
}
