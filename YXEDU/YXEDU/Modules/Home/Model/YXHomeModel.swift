//
//  YXHomeModel.swift
//  YXEDU
//
//  Created by Jake To on 11/1/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXHomeModel: Codable {
    var userId: Int?
    var bookId: Int?
    var bookName: String?
    var bookSource: String?
    var bookHash: String?
    var unitId: Int?
    var unitName: String?
    var isLastUnit: Int?
    var unitProgress: Double?
    var newWords: Int?
    var reviewWords: Int?
    var collectedWords: Int?
    var wrongWords: Int?
    var learnedWords: Int?
    var isSkipNewLearn: Int?
    var bookGrade: Int?
    var bookVersionName: String?
    
    enum CodingKeys: String, CodingKey {
        case userId          = "user_id"
        case bookId          = "book_id"
        case bookName        = "book_name"
        case bookSource      = "book_url"
        case bookHash        = "hash"
        case unitId          = "unit_id"
        case unitName        = "unit_name"
        case isLastUnit      = "is_last_unit"
        case unitProgress    = "learn_rate"
        case newWords        = "new_num"
        case reviewWords     = "review_num"
        case collectedWords  = "fav_num"
        case wrongWords      = "wrong_num"
        case learnedWords    = "learned_num"
        case isSkipNewLearn  = "is_skip_new_word_learn"
        case bookGrade       = "book_grade"
        case bookVersionName = "book_ver_name"
    }
}
