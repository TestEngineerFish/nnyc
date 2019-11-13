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
    var wordID: Int? = -1
    var word: String?
    var partOfSpeech: String?
    var meaning: String?
    var imageUrl: String?
    
    /// 音标
    var americanPhoneticSymbol: String?
    var englishPhoneticSymbol: String?
    
    /// 发音
    var americanPronunciation: String?
    var englishPronunciation: String?
    
    /// 例句
    var englishExample: String?
    var chineseExample: String?
    var examplePronunciation: String?
    
    var synonym: String?
    var antonym: String?
    var usage: [String]?

    var gradeId: Int? = -1
    var gardeType: Int? = 1
    var bookId: Int? = -1
    var unitId: Int? = -1
    var unitName: String?
    var isExtensionUnit: Bool = false

    // Matrix
    var column: Int = 0
    var row: Int = 0

    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordID <- map["word_id"]
        word <- map["word"]
        partOfSpeech <- map["word_property"]
        meaning <- map["word_paraphrase"]
        imageUrl <- map["word_image"]
        americanPhoneticSymbol <- map["symbol_us"]
        englishPhoneticSymbol <- map["symbol_uk"]
        americanPronunciation <- map["voice_us"]
        englishPronunciation <- map["voice_uk"]
        englishExample <- map["example_en"]
        chineseExample <- map["example_cn"]
        examplePronunciation <- map["example_voice"]
        synonym <- map["synonym"]
        antonym <- map["antonym"]
        usage <- map["usage_list"]
        column <- map["column"]
        row <- map["row"]
    }
    
    ///根据本地设置，获取音标
    var soundmark: String? {
        return YXUserModel.default.didUseAmericanPronunciation ? americanPhoneticSymbol : englishPhoneticSymbol
    }
    
    ///根据本地设置，获取语音
    var voice: String? {
        return YXUserModel.default.didUseAmericanPronunciation ? americanPronunciation : englishPronunciation
    }
}