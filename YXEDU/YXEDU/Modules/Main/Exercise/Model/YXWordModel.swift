//
//  YXWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/6.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 单词数据模型
class YXWordModel: NSObject {
    
    var wordId: Int = -1
    var unitId: Int = -1
    var bookId: Int = -1
    var isExtUnit: Bool = false
    var word: String?
    var property: String?   // 词性，例如 adj.
    var paraphrase: String?         //词义
    var example: String?
    var imageUrl: String?
    var synonym: String?            // 同义词
    var antonym: String?            // 反义词
    var usage: [String]?
    
    
    
}
