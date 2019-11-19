//
//  YXLearnMapModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 学习地图中的单元对象
struct YXLearnMapUnitModel: Mappable {

    var unitID: Int?
    var unitName: String?
    var wordsNumber: Int?
    var bookID: Int?
    var rate: Float = 0.0
    var stars: Int = 0
    var status = YXUnitLearnStatusType.uniteUnstart
    var ext: YXLearnMapUnitExtModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        unitID      <- map["unit_id"]
        unitName    <- map["unit_name"]
        wordsNumber <- map["words_num"]
        bookID      <- map["book_id"]
        rate        <- map["rate"]
        stars       <- map["stars"]
        status      <- map["status"]
        ext         <- map["ext"]
    }
}

/// 学习地图中的单元扩展对象
struct YXLearnMapUnitExtModel: Mappable {

    var unitID: Int?
    var unitName: String = ""
    var wordsNumber: Int?
    var bookID: Int?
    var rate: Double = 0.0
    var stars: Int = 0
    var status = YXUnitLearnStatusType.uniteUnstart

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        unitID      <- map["unit_id"]
        unitName    <- map["unit_name"]
        wordsNumber <- map["words_num"]
        bookID      <- map["book_id"]
        rate        <- map["rate"]
        stars       <- map["stars"]
        status      <- map["status"]
    }
}

/// 学习单元状态枚举
enum YXUnitLearnStatusType: Int {
    case uniteUnstart = 9
    case uniteStop    = 0
    case uniteIng     = 1
    case uniteEnd     = 2
}


