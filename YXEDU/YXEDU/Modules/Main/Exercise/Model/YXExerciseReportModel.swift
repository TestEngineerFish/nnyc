//
//  YXExerciseReportModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper


struct YXExerciseReportModel: Mappable {
    
    var wordId: Int = -1
    var bookId: Int = -1
    var unitId: Int = -1
    var score: Int = 0
    var result: ResultModel?
    
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
        
    mutating func mapping(map: Map) {
        wordId     <- map["word_id"]
        bookId <- map["book_id"]
        unitId   <- map["unit_id"]
        score   <- map["score"]
        result  <- map["result"]
    }
    
    
    struct ResultModel: Mappable {
        
        var one: Bool?
        var two: Bool?
        var three: Bool?
        var four: Bool?
        
        init() {}
        
        init?(map: Map) {
            self.mapping(map: map)
        }
            
        mutating func mapping(map: Map) {
            one     <- map["1"]
            two <- map["2"]
            three   <- map["3"]
            four  <- map["4"]
        }
    }
    
}
