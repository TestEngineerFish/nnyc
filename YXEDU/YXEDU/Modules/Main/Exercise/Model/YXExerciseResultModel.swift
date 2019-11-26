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
    var unitId: Int?
    var newWordIds: [Int]?
    var reviewWordIds: [Int]?
    var steps: [[YXExerciseStepModel]]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        bookId <- map["book_id"]
        newWordIds <- map["new_word_list"]
        reviewWordIds <- map["review_word_list"]
        steps <- map["step_list"]
    }
}

struct YXExerciseStepModel: Mappable {
    var wordId: Int = -1
    /// 是否根据得分选择题型
    var isCareScore: Bool = true
    /// 打分，用于选择哪个题型
    var score: Int = -1
    /// 题型
    var type: String?
    /// 第几步
    var step: Int = -1
    var isBackup: Bool = false
    
        /// 问题
    var question: YXWordModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 答案
    var answers: [Int]?
    
    init?(map: Map) {
    }
        
    mutating func mapping(map: Map) {
        wordId      <- map["word_id"]
        type        <- map["type"]
        isCareScore <- map["is_care_score"]
        score       <- map["score"]
        step        <- map["step"]
        isBackup    <- map["is_backup"]
        
        question    <- map["question"]
        option      <- map["option"]
        answers     <- map["answer_list"]
    }
    
}


/// 练习选项数据模型
struct YXExerciseOptionModel: Mappable {
    
    var firstItems: [YXOptionItemModel]?
    var secondItems: [YXOptionItemModel]?
    
    init() {}        
        
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
    
    init() {}
            
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        optionId <- map["option_id"]
        content <- map["content"]
    }
}
