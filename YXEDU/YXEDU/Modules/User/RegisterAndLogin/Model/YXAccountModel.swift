//
//  YXAccountModel.swift
//  YXEDU
//
//  Created by Jake To on 5/18/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXAccountModel: Mappable {
    var token: String?
    var uuid: String?
    var info: YXAccountInfoModel?

    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
        uuid <- map["uuid"]
        info <- map["user_info"]
    }
}

struct YXAccountInfoModel: Mappable {
    var username: String?
    var avatar: String?
    var uuid: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        username <- map["nick"]
        avatar   <- map["avatar"]
        uuid     <- map["uuid"]
    }
}

//struct YXTextModel: Mappable {
//
//}
