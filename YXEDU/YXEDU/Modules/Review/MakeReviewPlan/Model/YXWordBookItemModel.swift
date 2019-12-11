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
    var type: Int        = 0
    var name             = ""
    var wordsNumber: Int = 0
    var versionName      = ""
    var isLearning       = false
    var isSelected       = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["review_book_id"]
        type        <- map["review_book_type"]
        name        <- map["review_book_name"]
        wordsNumber <- map["review_book_num"]
        versionName <- map["review_book_ver_name"]
        isLearning  <- map["is_learning"]
    }
}

class YXReviewUnitModel: Mappable {

    var id: Int          = 0
    var name: String     = ""
    var wordsNumber: Int = 0
    var list: [YXReviewWordModel]          = []
    var isCheckAll: Bool {
        get {
            var checkAll = true
            for wordModel in list {
                if !wordModel.isSelected {
                    checkAll = false
                    break
                }
            }
            return checkAll
        }
    }
    var isOpenUp         = false

    required init?(map: Map) {}

    func mapping(map: Map) {
        id          <- map["unit_id"]
        name        <- map["unit_name"]
        wordsNumber <- map["words_num"]
        list        <- map["list"]
    }

}

class YXReviewParaphrase: Mappable {
    var key   = ""
    var value = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        key   <- map["k"]
        value <- map["v"]
    }
}

class YXReviewWordModel: Mappable, Equatable {

    var id: Int            = 0
    var word: String       = ""
    var voiceUs: String?
    var voiceUk: String?
    var paraphrase: [YXReviewParaphrase] = []
    var isLearn: Bool      = false
    var isSelected         = false
    var unitId = 0
    var bookId = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        id         <- map["word_id"]
        word       <- map["word"]
        voiceUs    <- map["voice_us"]
        voiceUk    <- map["voice_uk"]
        paraphrase <- map["paraphrase"]
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
