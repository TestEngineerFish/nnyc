//
//  YXExerciseWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 练习数据模型
struct YXWordExerciseModel: Mappable {
    
    var type: YXExerciseType = .none
        
    /// 对应的单词数据
    var word: YXWordModel?
    
    /// 问题（使用 word 模型）
    var question: YXWordModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 答案
    var answers: [Int]?
        
    /// 得分
    var score: Int?
        
    //MARK: - 以下几个属性用于本地记录进度时使用
    /// 是否根据得分选择题型
    var isCareScore: Bool = false
        
    /// 第几步
    var step: Int = 0    
    /// 对错
    var isRight: Bool?
    
    var isNewWord: Bool = false
        
    var isFinish: Bool = false
    

    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
        
    mutating func mapping(map: Map) {
        type     <- map["type"]
        question <- map["question"]
        option   <- map["option"]
        answers  <- map["answer_list"]
        score    <- map["score"]
        word     <- map["word"]
        
        isCareScore <- map["is_care_score"]
        step <- map["step"]
        isNewWord <- map["is_new_word"]
        isFinish <- map["is_finish"]
        isRight <- map["is_right"]
        
    }
    
}
