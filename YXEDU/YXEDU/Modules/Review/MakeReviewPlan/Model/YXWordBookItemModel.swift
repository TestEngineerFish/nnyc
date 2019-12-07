//
//  YXWordBookItemModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

struct YXReviewBookModel: Mappable {
    var list: [YXReviewWordBookItemModel] = []
    var currentModel: [YXReviewUnitModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        list         <- map["list"]
        currentModel <- map["cur_words"]
    }
}

struct YXReviewWordBookItemModel: Mappable {
    var id: Int          = 0
    var type: Int?
    var name: String     = ""
    var wordsNumber: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id          <- map["review_book_id"]
        type        <- map["review_book_type"]
        name        <- map["review_book_name"]
        wordsNumber <- map["review_book_num"]
    }
}

struct YXReviewUnitModel: Mappable {

    var id: Int          = 0
    var name: String     = ""
    var wordsNumber: Int = 0
    var list: [YXReviewWordModel]          = []
    var selectedWords: [YXReviewWordModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id          <- map["unit_id"]
        name        <- map["unit_name"]
        wordsNumber <- map["words_num"]
        list        <- map["list"]
    }
}

struct YXReviewWordModel: Mappable {
    var id: Int            = 0
    var word: String       = ""
    var property: String   = ""
    var paraphrase: String = ""
    var isLearn: Bool      = false


    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id         <- map["word_id"]
        word       <- map["word"]
        property   <- map["word_property"]
        paraphrase <- map["word_paraphrase"]
        isLearn    <- map["is_learn"]
    }
}
