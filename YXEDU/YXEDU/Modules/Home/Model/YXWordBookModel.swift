//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXBookListModel: Codable {
    var bookList: [YXGradeModel]?
    
    enum CodingKeys: String, CodingKey {
        case bookList = "book_list"
    }
}

struct YXGradeModel: Codable {
    var isSelect = false

    var gradeName: String?
    var wordBooks: [YXWordBookModel]?
    
    enum CodingKeys: String, CodingKey {
        case gradeName = "title"
        case wordBooks = "options"
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
    var hashCode: String?
    var unitList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case bookID = "book_id"
        case bookName = "book_name"
        case bookSource = "book_url"
        case coverImagePath = "cover"
        case hashCode = "hash"
        case unitList = "unit_list"
    }
}
