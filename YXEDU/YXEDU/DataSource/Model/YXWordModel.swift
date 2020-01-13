//
//  YXWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/6.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 单词数据模型
struct YXWordModel: YXBaseWordModel {
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
    
    // 是否是综合词
    var isComplexWord: Int?
    
    // 是否隱藏詞義
    var hidePartOfSpeechAndMeanings = true
    
    // 是否被選中
    var isSelected = false

    // 默認排序序號
    var index: Int!
    
    var column: Int = 0
    var row: Int = 0
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
        isComplexWord <- map["is_synthesis"]
    }
    
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
    var pronunciationUS: String?
    var pronunciationUK: String?
    var imageUrl: String?
    
    // 例句读音，根据本地美式或者英式设置来获取
    var vocie: String {
        return (YXUserModel.default.didUseAmericanPronunciation ? pronunciationUS : pronunciationUK) ?? ""
    }

    var englishExampleAttributedString: NSAttributedString? {
        guard let englishExample = english else { return nil }
        let result = englishExample.formartTag()
        let englishExampleAttributedString = NSMutableAttributedString(string: result.1)
        result.0.forEach { (range) in
            englishExampleAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
        }
        return englishExampleAttributedString
    }
    
    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        english <- map["en"]
        chinese <- map["cn"]
        pronunciationUS <- map["voice_us"]
        pronunciationUK <- map["voice_uk"]
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
