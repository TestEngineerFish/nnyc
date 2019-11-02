//
//  YXWordBookModel.swift
//  YXEDU
//
//  Created by Jake To on 10/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordBookModel: NSObject {
    var isSelected = false
    var isCurrentStudy = false
    var coverImage: UIImage?

    var bookID: Int?
    var bookName: String?
    var coverImagePath: String?
    var countOfWords: Int?
    var hashCode: String?
    var unitList: [String]?
}
