//
//  YXHomeModel.swift
//  YXEDU
//
//  Created by Jake To on 11/1/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXHomeModel: Mappable {
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
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        userId <- map["user_id"]
         bookId <- map["book_id"]
         bookName <- map["book_name"]
         bookSource <- map["book_url"]
         bookHash <- map["hash"]
         unitId <- map["unit_id"]
         unitName <- map["unit_name"]
         isLastUnit <- map["is_last_unit"]
         unitProgress <- map["learn_rate"]
         newWords <- map["new_num"]
         reviewWords <- map["review_num"]
         collectedWords <- map["fav_num"]
         wrongWords <- map["wrong_num"]
         learnedWords <- map["learned_num"]
         isSkipNewLearn <- map["is_skip_new_word_learn"]
         bookGrade <- map["book_grade"]
         bookVersionName <- map["book_ver_name"]
    }
}
