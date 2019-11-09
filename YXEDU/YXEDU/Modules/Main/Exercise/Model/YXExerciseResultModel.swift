//
//  YXExerciseResultModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper


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
    var wordId: Int = -1
    /// 是否新单词
    var isNewWord: Bool = false
    /// 步骤模型
    var steps: [[YXWordStepModel]]?
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        wordId <- map["word_id"]
        isNewWord <- map["is_new_word"]
        steps <- map["step_list"]
    }
}



struct YXWordStepModel: Mappable {
    
    /// 第几步
    var stepNum: Int = -1
    /// 打分，用于选择哪个题型
    var score: Int = -1
    var type: Int = -1
        /// 问题
    var question: YXWordModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 答案
    var answers: [Int]?
    
    init?(map: Map) {
    }
        
    mutating func mapping(map: Map) {
        stepNum <- map["step_num"]
        type <- map["type"]
        question <- map["question"]
        option <- map["option"]
        answers <- map["answer_list"]
        score <- map["score"]
    }
    
}


/// 练习选项数据模型
struct YXExerciseOptionModel: Mappable {
    
    var firstItems: [YXOptionItemModel]?
    var secondItems: [YXOptionItemModel]?
        
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        firstItems <- map["first"]
        secondItems <- map["second"]
    }
}




struct YXOptionItemModel: Mappable {
    var optionId: Int = -1
    var content: String?
        
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        optionId <- map["option_id"]
        content <- map["content"]
    }
}
