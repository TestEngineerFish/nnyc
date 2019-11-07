//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

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
