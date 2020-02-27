//
//  YXGuideModel.swift
//  YXEDU
//
//  Created by Jake To on 2/26/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXGuideModel: Mappable {
    var bookId: Int?
    var bookGrade: Int?
    var bookVersion: String?
    var bookName: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        bookId <- map["book_id"]
        bookGrade <- map["book_grade"]
        bookVersion <- map["book_ver_name"]
        bookName <- map["book_name"]
    }
}
