//
//  YXOCModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

@objc
class YXOCModel: NSObject, Mappable {

    @objc var summary: YXSummaryModel?
    @objc var detail: [YXSummaryDetialModel] = []

    @objc var date: Double = 0
    @objc var duration: Int = 0
    @objc var reviewItems: [YXSummaryItemsModel] = []
    @objc var studyItems: [YXSummaryItemsModel] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        summary     <- map["summary"]
        detail      <- map["study_detail"]
        date        <- map["date"]
        duration    <- map["study_duration"]
        reviewItems <- map["review_item"]
        studyItems  <- map["study_item"]
    }
}

@objc
class YXSummaryModel: NSObject, Mappable {

    @objc var days: Int     = 0
    @objc var words: Int    = 0
    @objc var duration: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        days     <- map["study_days"]
        words    <- map["study_words"]
        duration <- map["study_duration"]
    }
}

@objc
class YXSummaryDetialModel: NSObject, Mappable {

    @objc var date: Double = 0
    @objc var status: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        date   <- map["date"]
        status <- map["status"]
    }
}

@objc
class YXSummaryItemsModel: NSObject, Mappable {

    @objc var name: String = ""
    @objc var num: Int = 0
    @objc var wordList: [YXSummaryItemsWordModel] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        name     <- map["name"]
        num      <- map["num"]
        wordList <- map["word_list"]
    }
}

@objc
class YXSummaryItemsWordModel: NSObject, Mappable {

    @objc var wordId: Int = -1
    @objc var word: String = ""
    @objc var partOfSpeechAndMeanings: [YXSummaryItemsWordPartOfSpeechAndMeaningModel] = []
    @objc var americanPronunciation: String = ""
    @objc var englishPronunciation: String = ""
    @objc var isComplexWord: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        wordId                  <- map["word_id"]
        word                    <- map["word"]
        partOfSpeechAndMeanings <- map["paraphrase"]
        americanPronunciation   <- map["voice_us"]
        englishPronunciation    <- map["voice_uk"]
        isComplexWord          <- map["is_synthesis"]
    }
}

@objc
class YXSummaryItemsWordPartOfSpeechAndMeaningModel: NSObject, Mappable {
    @objc
    var partOfSpeech: String = ""
    
    @objc
    var meaning: String = ""
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        partOfSpeech <- map["k"]
        meaning      <- map["v"]
    }
}
