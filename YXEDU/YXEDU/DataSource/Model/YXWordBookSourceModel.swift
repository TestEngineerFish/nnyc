//
//  YXJSONWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 11/8/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper


// JSON 词书资源数据模型
struct YXWordBookSourceModel: Mappable {
    var units: [YXWordBookSourceUnitModel]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        units <- map["unit_list"]
    }
}

struct YXWordBookSourceUnitModel: Mappable {
    var words: [YXWordModel]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        words <- map["word_list"]
    }
}
