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
    var gradeId: Int? = -1
    var gardeType: Int? = 1
    var bookId: Int? = -1
    var unitId: Int? = -1
    var unitName: String?
    var isExtensionUnit: Bool = false
    var wordId: Int? = -1
    var word: String?
    var partOfSpeechAndMeanings: [YXWordPartOfSpeechAndMeaningModel]?
    var imageUrl: String?
    
    // 音标
    var americanPhoneticSymbol: String?
    var englishPhoneticSymbol: String?
    
    // 发音
    var americanPronunciation: String?
    var englishPronunciation: String?
    
    // 单词变形
    var deformations: [YXWordDeformationModel]?
    
    // 例句
    var examples: [YXWordExampleModel]?
        
    // 固定搭配
    var fixedMatchs: [YXWordFixedMatchModel]?
    
    // 常见短语
    var commonPhrases: [YXWordCommonPhrasesModel]?
    
    // 单词辨析
    var wordAnalysis: [YXWordAnalysisModel]?
    
    // 语法详解
    var detailedSyntaxs: [YXWordDetailedSyntaxModel]?

    // 同反义词
    var synonyms: [String]?
    var antonyms: [String]?
    
    // Matrix
    var column: Int = 0
    var row: Int = 0
    
    // 是否是综合词
    var isComplexWord: Int?
    
    // 是否隱藏詞義
    var hidePartOfSpeechAndMeanings = false
    
    // 是否被選中
    var isSelected = false
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordId                  <- map["word_id"]
        word                    <- map["word"]
        imageUrl                <- map["word_image"]
        partOfSpeechAndMeanings <- map["paraphrase"]
        americanPhoneticSymbol  <- map["symbol_us"]
        englishPhoneticSymbol   <- map["symbol_uk"]
        americanPronunciation   <- map["voice_us"]
        englishPronunciation    <- map["voice_uk"]
        examples                <- map["examples"]
        deformations            <- map["vary"]
        fixedMatchs             <- map["hold_match"]
        commonPhrases           <- map["common_short"]
        wordAnalysis            <- map["analysis"]
        detailedSyntaxs         <- map["grammar"]
        synonyms                <- map["synonym"]
        antonyms                <- map["antonym"]
        column                  <- map["column"]
        row                     <- map["row"]
        bookId                  <- map["book_id"]
        unitId                  <- map["unit_id"]
        isComplexWord           <- map["is_synthesis"]
    }
    
    ///根据本地设置，获取音标
    var soundmark: String? {
        return YXUserModel.default.didUseAmericanPronunciation ? americanPhoneticSymbol : englishPhoneticSymbol
    }
    
    ///根据本地设置，获取语音
    var voice: String? {
        return YXUserModel.default.didUseAmericanPronunciation ? americanPronunciation : englishPronunciation
    }
    
    var partOfSpeech: String? {
        return partOfSpeechAndMeanings?[0].partOfSpeech
    }
    
    var meaning: String? {
        set {
            partOfSpeechAndMeanings?[0].meaning = newValue
        }
        
        get {
            return partOfSpeechAndMeanings?[0].meaning
        }
    }
    var example: String? {
        return examples?[0].english
    }
    
    var chineseExample: String? {
        return examples?[0].chinese
    }
    
    var examplePronunciation: String? {
        set {
            examples?[0].pronunciation = newValue
        }
        
        get {
            return examples?[0].pronunciation
        }
    }
    
    var englishExampleAttributedString: NSAttributedString? {
        guard let englishExample = examples?[0].english else { return nil }

        let firstRightBracket = englishExample.firstIndex(of: ">")!
        let startHighLightIndex = englishExample.index(firstRightBracket, offsetBy: 1)
        let lastLeftBracket = englishExample.lastIndex(of: "<")!
        let highLightString = String(englishExample[startHighLightIndex..<lastLeftBracket])
        
        let firstLeftBracket = englishExample.firstIndex(of: "<")!
        let lastRightBracket = englishExample.lastIndex(of: ">")!
        let endHighLightIndex = englishExample.index(lastRightBracket, offsetBy: 1)
        let string = String(englishExample[englishExample.startIndex..<firstLeftBracket]) + highLightString + String(englishExample[endHighLightIndex..<englishExample.endIndex])
        
        let attrString = NSMutableAttributedString(string: string)
        let highLightRange = string.range(of: highLightString)!
        let highLightLocation = string.distance(from: string.startIndex, to: highLightRange.lowerBound)
        attrString.addAttributes([.foregroundColor: UIColor.hex(0xFBA217)], range: NSRange(location: highLightLocation, length: highLightString.count))
        
        return attrString
    }
}

/// Review
extension YXWordModel {
    
}


struct YXWordPartOfSpeechAndMeaningModel: Mappable {
    var partOfSpeech: String?
    var meaning: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        partOfSpeech <- map["k"]
        meaning <- map["v"]
    }
}



struct YXWordExampleModel: Mappable {
    var english: String?
    var chinese: String?
    var pronunciation: String?
    var imageUrl: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        english <- map["en"]
        chinese <- map["cn"]
        pronunciation <- map["voice"]
        imageUrl <- map["image"]
    }
}



struct YXWordDeformationModel: Mappable {
    var deformation: String?
    var word: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        deformation <- map["k"]
        word <- map["v"]
    }
}



struct YXWordFixedMatchModel: Mappable {
    var english: String?
    var chinese: String?
    var englishExample: String?
    var chineseExample: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        english <- map["match_en"]
        chinese <- map["match_cn"]
        englishExample <- map["example_en"]
        chineseExample <- map["example_cn"]
    }
}



struct YXWordCommonPhrasesModel: Mappable {
    var english: String?
    var chinese: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        english <- map["k"]
        chinese <- map["v"]
    }
}



struct YXWordAnalysisModel: Mappable {
    var title: String?
    var list: [String]?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        list <- map["list"]
    }
}


struct YXWordDetailedSyntaxModel: Mappable {
    var title: String?
    var list: [String]?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        list <- map["list"]
    }
}
