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
    var bookId: Int?
    var unitId: Int?
    var score: Int = 0
    var errorCount: Int = 0
    var result: ResultModel?
    
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
        
    mutating func mapping(map: Map) {
        wordId     <- map["word_id"]
        bookId     <- map["book_id"]
        unitId     <- map["unit_id"]
        score      <- map["score"]
        errorCount <- map["error_count"]
        result     <- map["result"]
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
            one   <- map["1"]
            two   <- map["2"]
            three <- map["3"]
            four  <- map["4"]
        }
    }
    
}

struct YXListenScoreModel: Mappable {
    
    var listenScore: Int = 0
    var coin: Int        = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        listenScore <- map["listen_score"]
        coin        <- map["coin"]
    }
}
