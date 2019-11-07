//
//  YXExerciseWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper


///// 单词练习数据模型
//struct YXWordExerciseModel: Mappable {
//
//    var type: YXExerciseType = .none
//    // 题目:填空题,选择字母
//    var charModelArray = [YXCharacterModel]()
//    // 答案: 填空题
//    var wordArray = [String]()
//    // 答题: 连词
//    var matix: Int = 4
//    var word: String = "Notification"
//    var score: Int = 0
//    var subTitle = "n.咖啡"
//    // 填空- 图片地址
//    var imageUrl: String = "http://e.hiphotos.baidu.com/image/h%3D300/sign=907f6e689ddda144c5096ab282b6d009/dc54564e9258d1092f7663c9db58ccbf6c814d30.jpg"
//
//    init(_ type: YXExerciseType) {
//        self.type = type
//    }
//
//    init?(map: Map) {
//    }
//
//
//    mutating func mapping(map: Map) {
//
//    }
//}
//



/// 当天学习数据总j模型
struct YXExerciseResultModel: Mappable {

    var bookId: Int?
    var newWords: [Int]?
    var reviewWords: [YXReviewWordModel]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        bookId <- map["book_id"]
        newWords <- map["new_word_list"]
        reviewWords <- map["review_word_list"]
    }
}


/// 复习单词数据模型
struct YXReviewWordModel: Mappable {
    var wordId: Int?
    /// 是否新单词
    var isNewWord: Bool?
    /// 练习模型
    var exercises: [YXWordExerciseModel]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        wordId <- map["word_id"]
        isNewWord <- map["is_new_word"]
        exercises <- map["exercise_list"]
    }
}


/// 练习数据模型
struct YXWordExerciseModel: Mappable {
    
    var type: YXExerciseType = .none
    var word: YXWordModel?
    /// 问题
    var question: YXWordModel?
    /// 选项
    var options: [YXExerciseOptionModel]?
    /// 答案
    var answers: [Int]?
        
    /// 得分
    var score: Int?

    init?(map: Map) {
    }
        
    mutating func mapping(map: Map) {
        type <- map["type"]
        question <- map["question"]
        options <- map["option_list"]
        answers <- map["answer_list"]
        score <- map["score"]
    }
    
}


/// 练习选项数据模型
struct YXExerciseOptionModel: Mappable {
    
    var optionId: Int = -1
    var content: String?
        
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        optionId <- map["option_id"]
        content <- map["content"]
    }
}

