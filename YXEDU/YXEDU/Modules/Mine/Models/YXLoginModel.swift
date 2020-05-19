//
//  YXLoginModel.swift
//  YXEDU
//
//  Created by Jake To on 5/18/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXNewLoginModel: Mappable {
    var user: YXNewLoginUserInfoModel?
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

struct YXNewLoginUserInfoModel: Mappable {
    var avatar: String?
    var nick: String?
    var sex: Int?
    var area: String?
    var mobile: String?
    var uuid: String?
    var birthday: String?
    var speech: String?
    var userBind: String?
    var grade: String?
    var punchDays: Int?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        avatar                       <- map["avatar"]
        nick                  <- map["nick"]
        sex                     <- map["sex"]
        area              <- map["area"]
        mobile                       <- map["mobile"]
        uuid                  <- map["uuid"]
        userBind                     <- map["userBind"]
        birthday              <- map["birthday"]
        speech              <- map["speech"]
        grade              <- map["grade"]
        punchDays              <- map["punchDays"]
    }
}
