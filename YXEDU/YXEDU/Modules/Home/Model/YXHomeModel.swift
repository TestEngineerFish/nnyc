//
//  YXHomeModel.swift
//  YXEDU
//
//  Created by Jake To on 11/1/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXHomeModel: Codable {
    var userID: Int?
    var bookID: Int?
    var bookName: String?
    var unitID: Int?
    var unitName: String?
    var unitProgress: Double?
    var newWords: Int?
    var reviewWords: Int?
    var collectedWords: Int?
    var wrongWords: Int?
    var learnedWords: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case bookID = "book_id"
        case bookName = "book_name"
        case unitID = "unit_id"
        case unitName = "unit_name"
        case unitProgress = "learn_rate"
        case newWords = "new_num"
        case reviewWords = "review_num"
        case collectedWords = "fav_num"
        case wrongWords = "wrong_num"
        case learnedWords = "learned_num"
    }
}
