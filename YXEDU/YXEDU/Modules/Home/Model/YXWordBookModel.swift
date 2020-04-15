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

    var gradeId: Int?
    var gradeName: String?
    var wordBooks: [YXWordBookModel]?
    
    lazy var versions: [YXWordVersionModel] = {
        guard let wordBooks = wordBooks, wordBooks.count > 0 else { return [] }
        
        var versions: [YXWordVersionModel] = []
        versions.append(YXWordVersionModel(bookVersionId:0, bookVersion: "所有版本"))
        
        for wordBook in wordBooks {
            if versions.contains(where: { $0.bookVersion == wordBook.bookVersionName }) {
                continue
                
            } else {
                versions.append(YXWordVersionModel(bookVersionId: wordBook.bookVersionId, bookVersion: wordBook.bookVersionName))
            }
        }
        
        if versions.count > 0 {
            versions[0].isSelect = true
        }
        
        return versions
    }()
    
    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        gradeId <- map["grade_id"]
        gradeName <- map["grade_name"]
        wordBooks <- map["book_list"]
    }
}

struct YXWordVersionModel {
    var isSelect = false
    var bookVersionId: Int?
    var bookVersion: String?
}

struct YXWordBookModel: Mappable {
    var isSelected = false
    var isCurrentStudy = false
    var isNewWordBook = false
    var coverImage: UIImage?
    
    var gradeId: Int?
    var gradeType: Int?
    var bookId: Int?
    var bookName: String?
    var bookShortName: String?
    var bookWordSourcePath: String?
    var bookMaterialSourcePath: String?
    var coverImagePath: String?
    var countOfWords: Int?
    var didFinished: Int?
    var bookHash: String?
    var units: [YXWordBookUnitModel]?
    var bookVersionId: Int?
    var bookVersionName: String?
    var bookGrade: Int?

    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        gradeId                <- map["grade_id"]
        bookId                 <- map["book_id"]
        bookName               <- map["book_name"]
        bookWordSourcePath     <- map["book_json_url"]
        bookMaterialSourcePath <- map["book_url"]
        coverImagePath         <- map["cover"]
        countOfWords           <- map["words_num"]
        didFinished            <- map["is_learn_finish"]
        bookHash               <- map["hash"]
        units                  <- map["unit_list"]
        bookVersionId          <- map["book_ver_id"]
        bookVersionName        <- map["book_ver_name"]
        bookShortName          <- map["book_comment"]
        bookGrade              <- map["book_grade"]
    }
}

struct YXWordBookUnitModel: Mappable {
    var unitId: Int?
    var unitName: String?
    var isLastLearnUnit: Int?
    var isExtensionUnit: Bool = false
    var words: [YXWordModel]?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        unitId <- map["unit_id"]
        unitName <- map["unit_name"]
        isLastLearnUnit <- map["is_last_learn_unit"]
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

struct YXWordBookStatusModel: Mappable {
    var bookId: Int?
    var learnedDays: Int?
    var learnedWordsCount: Int?
    var unitId: Int?
    var learningUnit: String?
    var gradeId: Int?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        bookId <- map["book_id"]
        learnedDays <- map["learned_days"]
        learnedWordsCount <- map["learned_words"]
        unitId <- map["unit_id"]
        learningUnit <- map["learning_unit"]
        gradeId <- map["grade_id"]
    }
}
