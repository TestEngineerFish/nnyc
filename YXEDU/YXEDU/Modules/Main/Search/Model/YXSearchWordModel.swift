//
//  YXSearchWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXSearchWordModel: YXBaseWordModel {

    var wordId: Int?
    var word: String?
    var americanPronunciation: String?
    var englishPronunciation: String?
    var partOfSpeechAndMeanings: [YXWordPartOfSpeechAndMeaningModel]?
    // 音标
    var americanPhoneticSymbol: String?
    var englishPhoneticSymbol: String?
    
    var isLearn: Bool = false
    // 是否是综合词
    var isComplexWord: Int?
    
    init() {}
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        baseMapping(map: map)
        isLearn <- map["is_learn"]
        isComplexWord <- map["is_synthesis"]
    }
}


struct YXSearchWordListModel: Mappable {
    
    var words: [YXSearchWordModel]?
    
    init?(map: Map) {
    }
        
    mutating func mapping(map: Map) {
        words <- map["list"]
    }
}


