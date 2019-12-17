//
//  YXGameModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXGameModel:Mappable  {
    var state: Bool = true
    var config: YXGameConfig?
    var wordModelList: [YXGameWordModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        state         <- map["state"]
        config        <- map["gameConf"]
        wordModelList <- map["gameContent"]
    }
}

struct YXGameConfig: Mappable {

    var gameId: Int              = 0
    var totalTime: Int           = 0
    var totalQuestionNumber: Int = 0
    var timeOut: Int             = 0
    var version: Int             = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        gameId              <- map["game_id"]
        totalTime           <- map["total_time"]
        totalQuestionNumber <- map["total_num"]
        timeOut             <- map["time_out"]
    }
}

struct YXGameWordModel: Mappable {

    var wordId: Int     = 0
    var word: String    = ""
    var nature: String  = ""
    var meaning: String = ""
    var row: Int        = 0
    var column: Int     = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        wordId  <- map["word_id"]
        word    <- map["word"]
        nature  <- map["nature"]
        meaning <- map["meaning"]
        row     <- map["row"]
        column  <- map["column"]
    }
}

struct YXGameResultModel: Mappable {

    var state: Int          = 0
    var ranking: Int        = 0
    var questionNumber: Int = 0
    var consumeTime: Double = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        state   <- map["state"]
        ranking <- map["ranking"]
    }
}


