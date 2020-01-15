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
    var type: YXExerciseDataType = .base
    var bookId: Int?
    var unitId: Int?
    var newWordIds: [Int]?
    var reviewWordIds: [Int]?
    var steps: [[YXWordExerciseModel]]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        type <- (map["review_type"], YXExerciseDataTypeTransform())
        bookId <- map["book_id"]
        unitId <- map["unit_id"]
        newWordIds <- map["new_word_list"]
        reviewWordIds <- map["review_word_list"]
        steps <- map["step_list"]
    }
}

//struct YXExerciseStepModel: Mappable {
//    var wordId: Int = -1
//    /// 是否根据得分选择题型
//    var isCareScore: Bool = true
//    /// 打分，用于选择哪个题型
//    var score: Int = -1
//    /// 题型
//    var type: String?
//    /// 第几步
//    var step: Int = -1
//    var isBackup: Bool = false
//    var isNewWord: Bool = false
//        /// 问题
//    var question: YXWordModel?
//    /// 选项
//    var option: YXExerciseOptionModel?
//    /// 答案
//    var answers: [Int]?
//
//    init?(map: Map) {
//    }
//
//    mutating func mapping(map: Map) {
//        wordId      <- map["word_id"]
//        type        <- map["type"]
//        isCareScore <- map["is_care_score"]
//        score       <- map["score"]
//        step        <- map["step"]
//        isBackup    <- map["is_backup"]
//        isNewWord <- map["is_new_word"]
//
//        question    <- map["question"]
//        option      <- map["option"]
//        answers     <- map["answer_list"]
//    }
//
//}

/// 问题数据模型
struct YXExerciseQuestionModel: Mappable {

    var wordId: Int? = -1
    var word: String?
    var itemCount: Int = 4
    var column: Int = 0
    var row: Int = 0

    init() {}
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        wordId    <- map["word_id"]
        word      <- map["word"]
        itemCount <- map["select_item_num"]
        column    <- map["column"]
        row       <- map["row"]
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
    var optionId: Int    = -1
    var content: String?
    var isDisable: Bool = false
    
    init() {}
            
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        optionId <- map["option_id"]
        content <- map["content"]
    }
}




struct YXExerciseDataTypeTransform: TransformType {
        
    typealias Object = YXExerciseDataType
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> YXExerciseDataType? {
        if let v = value as? Int, let state = YXExerciseDataType(rawValue: v) {
            return state
        }
        return .base
    }
    
    func transformToJSON(_ value: YXExerciseDataType?) -> Int? {
        return value?.rawValue
    }

}
