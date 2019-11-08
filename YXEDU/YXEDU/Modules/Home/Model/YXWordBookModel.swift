//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit



// MARK: - 新增词书
struct YXGradeListModel: Codable {
    var gradeList: [YXGradeModel]?
    
    enum CodingKeys: String, CodingKey {
        case gradeList = "grade_list"
    }
}

struct YXGradeModel: Codable {
    var isSelect = false

    var gradeID: Int?
    var gradeName: String?
    var wordBooks: [YXWordBookModel]?
    
    enum CodingKeys: String, CodingKey {
        case gradeID = "grade_id"
        case gradeName = "grade_name"
        case wordBooks = "book_list"
    }
}

struct YXWordBookModel: Codable {
    var isSelected = false
    var isCurrentStudy = false
    var coverImage: UIImage?

    var bookID: Int?
    var bookName: String?
    var bookSource: String?
    var coverImagePath: String?
    var countOfWords: Int?
    var hashCode: Double?
    var unitList: [YXWordBookUnitModel]?
    
    enum CodingKeys: String, CodingKey {
        case bookID = "book_id"
        case bookName = "book_name"
        case bookSource = "book_url"
        case coverImagePath = "cover"
        case hashCode = "hash"
        case unitList = "unit_list"
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
struct YXAllWordBookModel: Codable {
    var currentLearnWordBook: YXSelectWordBookModel?
    var learnedWordBooks: [YXSelectWordBookModel]?

    enum CodingKeys: String, CodingKey {
        case currentLearnWordBook = "learning"
        case learnedWordBooks = "learned"
    }
}

struct YXSelectWordBookModel: Codable {
    var isSelected = false
    var isNewWordBook = false
    var isCurrentStudy = false

    var bookID: Int?
    var bookName: String?
    var bookSource: String?
    var countOfTotalWords: Int?
    var countOfLearnedWords: Int?
    var countOfLearnedDays: Int?
    var unitID: Int?
    var unitName: String?

    enum CodingKeys: String, CodingKey {
        case bookID = "bookId"
        case bookName = "bookName"
        case bookSource = "resUrl"
        case countOfTotalWords = "wordCount"
        case countOfLearnedWords = "learnCount"
        case countOfLearnedDays = "countOfLearnedDays"
        case unitID = "unit"
        case unitName = "unitName"
    }
}
