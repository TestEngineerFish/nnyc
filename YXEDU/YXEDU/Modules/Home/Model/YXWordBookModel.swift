//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper



// MARK: - 新增词书
struct YXGradeWordBookListModel: Mappable {
    var isSelect = false

    var gradeName: String?
    var wordBooks: [YXWordBookModel]?
    
    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        gradeName <- map["grade_name"]
        wordBooks <- map["book_list"]
    }
}

struct YXWordBookModel: Mappable {
    var isSelected = false
    var isCurrentStudy = false
    var isNewWordBook = false
    var coverImage: UIImage?
    
    var grade: Int?
    var gradeType: Int?
    var bookId: Int?
    var bookName: String?
    var bookSource: String?
    var coverImagePath: String?
    var countOfWords: Int?
    var bookHash: String?
    var units: [YXWordBookUnitModel]?
    
    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        grade <- map["book_grade"]
        bookId <- map["book_id"]
        bookName <- map["book_name"]
        bookSource <- map["book_url"]
        coverImagePath <- map["cover"]
        countOfWords <- map["?"]
        bookHash <- map["hash"]
        units <- map["unit_list"]
    }
}

struct YXWordBookUnitModel: Mappable {
    var unitId: Int?
    var unitName: String?
    var isExtensionUnit: Bool = false
    var words: [YXWordModel]?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        unitId <- map["unit_id"]
        unitName <- map["unit_name"]
        isExtensionUnit <- map["is_ext_unit"]
        words <- map["word_list"]
    }
}



// MARK: - 选择词书
struct YXUserWordBookListModel: Mappable {
    var currentLearnWordBookStatus: YXWordBookStatusModel?
    var learnedWordBooks: [YXWordBookModel]?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        currentLearnWordBookStatus <- map["user_current_book_status"]
        learnedWordBooks <- map["user_book_list"]
    }
}

struct YXWordBookStatusModel: Codable {
    var bookId: Int?
    var learnedDays: Int?
    var learnedWordsCount: Int?
    var learningUnit: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        bookId <- map["book_id"]
        learnedDays <- map["learned_days"]
        learnedWordsCount <- map["learned_words"]
        learningUnit <- map["learning_unit"]
    }
}
