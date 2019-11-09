//
//  YXWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/6.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 单词数据模型
struct YXWordModel: Mappable {
    var wordId: Int = -1
    var unitId: Int = -1
    var bookId: Int = -1
    var isExtUnit: Bool = false
    var word: String?
    var property: String?           // 词性，例如 adj.
    var paraphrase: String?         // 词义
    
    // 音标
    var soundmarkUK: String?
    var soundmarkUS: String?
        
    // 发音
    var voiceUK: String?
    var voiceUS: String?
    
    var examples: [YXWordExampleModel]?                      // 例句
    var imageUrl: String?
    var synonym: String?            // 同义词
    var antonym: String?            // 反义词
    var usage: [String]?
    
    // ext
    var gradeId: Int = -1
    var unitName: String?
    var gardeType: Int = 1   //年级类型
    init() {
        
    }
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordId <- map["word_id"]
        unitId <- map["unit_id"]
        bookId <- map["book_id"]
        isExtUnit <- map["is_ext_unit"]
        word <- map["word"]
        property <- map["property"]
        paraphrase <- map["paraphrase"]
        soundmarkUK <- map["soundmark_uk"]
        soundmarkUS <- map["soundmark_us"]
        voiceUK <- map["voice_uk"]
        voiceUS <- map["voice_us"]
        examples <- map["example_list"]
        imageUrl <- map["image"]
        synonym <- map["synonym"]
        antonym <- map["antonym"]
        usage <- map["usage"]
        
        
        gradeId <- map["grade_id"]
        unitName <- map["unit_name"]
    }
}


/// 例句数据模型
struct YXWordExampleModel: Mappable {
    
    var en: String?
    var cn: String?
    var voiceUrl: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        en <- map["en"]
        cn <- map["cn"]
        voiceUrl <- map["voice"]
    }
    
}









//
///// 发音数据模型
//struct YXWordPronunciationModel: Mappable {
//
//    var type: String?
//    var symbol: String?
//    var voiceUrl: String?
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
////        type <- map["type"]
//        symbol <- map["symbol"]
//        voiceUrl <- map["voice"]
//    }
//
//}
