//
//  YXLearnResultModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXLearnResultModel: Mappable {
    enum CountStatusType: Int {
        case end, ing
    }
    var countStatus: CountStatusType?
    var allWordCount: Int = 0
    var unitList: [YXLearnMapUnitModel]?
    

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        countStatus <- map["count_status"]
        allWordCount <- map["all_words_num"]        
        unitList    <- map["list"]
    }
}
