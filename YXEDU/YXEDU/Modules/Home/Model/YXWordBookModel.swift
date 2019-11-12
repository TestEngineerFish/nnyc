//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit



// MARK: - 新增词书
struct YXGradeWordBookListModel: Codable {
    var isSelect = false

    var gradeName: String?
    var wordBooks: [YXWordBookModel]?
    
    enum CodingKeys: String, CodingKey {
        case gradeName = "grade_name"
        case wordBooks = "book_list"
    }
}

struct YXWordBookModel: Codable {
    var isSelected = false
    var isCurrentStudy = false
    var isNewWordBook = false
    var coverImage: UIImage?
    
    var grade: Int?
    var bookID: Int?
    var bookName: String?
    var bookSource: String?
    var coverImagePath: String?
    var countOfWords: Int?
    var hashString: Int?
    var unitList: [YXWordBookUnitModel]?
    
    enum CodingKeys: String, CodingKey {
        case bookID = "book_id"
        case bookName = "book_name"
        case bookSource = "book_url"
        case coverImagePath = "cover"
        case hashString = "hash"
        case unitList = "unit_list"
        case grade = "book_grade"
    }
}

struct YXWordBookUnitModel: Codable {
    var unitID: Int?
    var unitName: String?
    
    enum CodingKeys: String, CodingKey {
        case unitID = "unit_id"
        case unitName = "unit_name"
    }
}



// MARK: - 选择词书
struct YXUserWordBookListModel: Codable {
    var currentLearnWordBookStatus: YXWordBookStatusModel?
    var learnedWordBooks: [YXWordBookModel]?

    enum CodingKeys: String, CodingKey {
        case currentLearnWordBookStatus = "user_current_book_status"
        case learnedWordBooks = "user_book_list"
    }
}

struct YXWordBookStatusModel: Codable {
    var bookID: Int?
    var learnedDays: Int?
    var learnedWordsCount: Int?
    var learningUnit: String?
    
    enum CodingKeys: String, CodingKey {
        case bookID = "book_id"
        case learnedDays = "learned_days"
        case learnedWordsCount = "learned_words"
        case learningUnit = "learning_unit"
    }
}
