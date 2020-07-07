//
//  YXCityModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXCityModel: Mappable {
    var id: Int      = 0
    var name: String = ""
    var areaList     = [YXAreaModel]()
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        areaList <- map["city"]
    }
}

struct YXAreaModel: Mappable {
    var id: Int      = 0
    var name: String = ""
    var localList    = [YXLocalModel]()
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id        <- map["id"]
        name      <- map["name"]
        localList <- map["area"]
    }
}

struct YXLocalModel: Mappable {
    var id: Int      = 0
    var name: String = ""

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id   <- map["id"]
        name <- map["name"]
    }
}
