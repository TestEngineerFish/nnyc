//
//  YXBaseWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 单词协议，所有单词使用场景均可以实现该协议，实习类必须重写使用的字段，也可以添加新的字段
protocol YXBaseWordModel: Mappable {
    var wordId: Int? {set get}
    var word: String? {set get}
    
    var gradeId: Int? {set get}
    var gardeType: Int? {set get}
    var bookId: Int? {set get}
    var unitId: Int? {set get}
    var unitName: String? {set get}
    var isExtensionUnit: Bool {set get}
    var partOfSpeechAndMeanings: [YXWordPartOfSpeechAndMeaningModel]? {set get}
    var imageUrl: String? {set get}
    
//    var phrase: 
    // 音标
    var americanPhoneticSymbol: String? {set get}
    var englishPhoneticSymbol: String? {set get}
    
    // 发音
    var americanPronunciation: String? {set get}
    var englishPronunciation: String? {set get}
    
    // 单词变形
    var deformations: [YXWordDeformationModel]? {set get}
    
    // 例句
    var examples: [YXWordExampleModel]? {set get}
        
    // 固定搭配
    var fixedMatchs: [YXWordFixedMatchModel]? {set get}
    
    // 常见短语
    var commonPhrases: [YXWordCommonPhrasesModel]? {set get}
    
    // 单词辨析
    var wordAnalysis: [YXWordAnalysisModel]? {set get}
    
    // 语法详解
    var detailedSyntaxs: [YXWordDetailedSyntaxModel]? {set get}
    // Matrix
    var column: Int {set get}
    var row: Int    {set get}
    // 同反义词
    var synonyms: [String]? {set get}
    var antonyms: [String]? {set get}
}

extension YXBaseWordModel {
    var wordId: Int? {set{} get{return 0}}
    var word: String? {set{} get{return nil}}
    
    var gradeId: Int? {set{} get{return 0}}
    var gardeType: Int? {set{} get{return 0}}
    var bookId: Int? {set{} get{return 0}}
    var unitId: Int? {set{} get{return 0}}
    var unitName: String? {set{} get{return nil}}
    var isExtensionUnit: Bool {set{} get{return false}}
    var partOfSpeechAndMeanings: [YXWordPartOfSpeechAndMeaningModel]? {set{} get{return nil}}
    var imageUrl: String? {set{} get{return nil}}
    
    // 音标
    var americanPhoneticSymbol: String? {set{} get{return nil}}
    var englishPhoneticSymbol: String? {set{} get{return nil}}
    
    // 发音
    var americanPronunciation: String? {set{} get{return nil}}
    var englishPronunciation: String? {set{} get{return nil}}
    
    // 单词变形
    var deformations: [YXWordDeformationModel]? {set{} get{return nil}}
    
    // 例句
    var examples: [YXWordExampleModel]? {set{} get{return nil}}
        
    // 固定搭配
    var fixedMatchs: [YXWordFixedMatchModel]? {set{} get{return nil}}
    
    // 常见短语
    var commonPhrases: [YXWordCommonPhrasesModel]? {set{} get{return nil}}
    
    // 单词辨析
    var wordAnalysis: [YXWordAnalysisModel]? {set{} get{return nil}}
    
    // 语法详解
    var detailedSyntaxs: [YXWordDetailedSyntaxModel]? {set{} get{return nil}}

    // Matrix
    var column: Int {set{} get{return 0}}
    var row: Int    {set{} get{return 0}}

    // 同反义词
    var synonyms: [String]? {set{} get{return nil}}
    var antonyms: [String]? {set{} get{return nil}}

    
    mutating func baseMapping(map: Map) {
        mappingProcess(map: map)
    }
    
    mutating func mapping(map: Map) {
        mappingProcess(map: map)
    }
    
    private mutating func mappingProcess(map: Map) {
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
        bookId                  <- map["book_id"]
        unitId                  <- map["unit_id"]
        column                  <- map["column"]
        row                     <- map["row"]
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
        return partOfSpeechAndMeanings?.first?.partOfSpeech
    }
    
    var meaning: String? {
        set {
            if !(partOfSpeechAndMeanings?.isEmpty ?? false) {
                partOfSpeechAndMeanings?[0].meaning = newValue
            }
        }
        
        get {
            return partOfSpeechAndMeanings?.first?.meaning
        }
    }
    var example: String? {
        return examples?.first?.english
    }
    
    var chineseExample: String? {
        return examples?.first?.chinese
    }
    
    var examplePronunciation: String? {
        set {
            examples?[0].pronunciation = newValue
        }
        
        get {
            return examples?.first?.pronunciation
        }
    }
    
    var englishExampleAttributedString: NSAttributedString? {
        var englishExampleAttributedString: NSMutableAttributedString?
        guard let englishExample = examples?.first?.english else { return englishExampleAttributedString }
        let result = englishExample.formartTag()
        englishExampleAttributedString = NSMutableAttributedString(string: result.1)
        result.0.forEach { (range) in
            englishExampleAttributedString?.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange1], range: range)
        }
        return englishExampleAttributedString
    }
}
