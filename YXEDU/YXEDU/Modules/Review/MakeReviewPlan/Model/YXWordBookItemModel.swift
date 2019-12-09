//
//  YXWordBookItemModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

class YXReviewBookModel: Mappable {
    var list: [YXReviewWordBookItemModel] = []
    var currentModel: [YXReviewUnitModel] = []
    var modelDict: [String:[YXReviewUnitModel]] = [:]

    required init?(map: Map) {}

    func mapping(map: Map) {
        list         <- map["list"]
        currentModel <- map["cur_words"]
    }
}

class YXReviewWordBookItemModel: Mappable {
    var id: Int          = 0
    var type: Int?
    var name: String     = ""
    var wordsNumber: Int = 0
    var isLearning       = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["review_book_id"]
        type        <- map["review_book_type"]
        name        <- map["review_book_name"]
        wordsNumber <- map["review_book_num"]
        isLearning  <- map["is_learning"]
    }
}

class YXReviewUnitModel: Mappable, Equatable {

    var id: Int          = 0
    var name: String     = ""
    var wordsNumber: Int = 0
    var list: [YXReviewWordModel]          = []
    var isCheckAll       = false
    var isOpenUp         = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["unit_id"]
        name        <- map["unit_name"]
        wordsNumber <- map["words_num"]
        list        <- map["list"]
    }

    static func == (lhs: YXReviewUnitModel, rhs: YXReviewUnitModel) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
}

class YXReviewWordModel: Mappable, Equatable {
    var id: Int            = 0
    var word: String       = ""
    var property: String   = ""
    var paraphrase: String = ""
    var isLearn: Bool      = false
    var isSelected         = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id         <- map["word_id"]
        word       <- map["word"]
        property   <- map["word_property"]
        paraphrase <- map["word_paraphrase"]
        isLearn    <- map["is_learn"]
    }

    static func == (lhs: YXReviewWordModel, rhs: YXReviewWordModel) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }

}
