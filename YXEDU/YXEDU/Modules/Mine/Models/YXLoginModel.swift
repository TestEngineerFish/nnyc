//
//  YXLoginModel.swift
//  YXEDU
//
//  Created by Jake To on 5/18/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXNewLoginModel: Mappable {
    var user: YXUserModel?
    var learningBook: YXWordBookModel?
    var bookList: [YXWordBookModel]?
    var notify: Int?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        user                       <- map["user"]
        learningBook                  <- map["learning"]
        bookList                     <- map["booklist"]
        notify              <- map["notify"]
    }
}
