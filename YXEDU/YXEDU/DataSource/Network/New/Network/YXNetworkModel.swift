//
//  YXNetworkModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//


import ObjectMapper

struct YXNetworkModel: Mappable {
    var token: String = ""
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        token <- map["token"]
    }
}

