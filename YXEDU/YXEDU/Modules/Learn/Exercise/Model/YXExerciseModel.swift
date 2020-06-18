//
//  YXExerciseWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

/// 练习数据模型
struct YXExerciseModel: Mappable {
    // id，数据库自增
    var eid: Int = 0
    var stepId: Int = 0
    var ruleModel: YXExerciseRuleModel?
    
    // 题型
    var type: YXQuestionType = .none
    // 学习类型
    var learnType: YXLearnType = .base
    // 练习规则
//    var rule: YXExerciseRule = .p0
        
    /// 对应的单词数据
    var wordId: Int = 0
    var word: YXWordModel?
    
    var n3List: [YXExerciseModel] = []
    
    /// 问题
    var question: YXExerciseQuestionModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 扩展
    var operate: YXNewExerciseOperateModel?
    /// 答案
    var answers: [Int]?
    /// 得分【这个字段有歧义，开始是当题型分数来使用的，后面做了答题分数在用，后面要改】
    var score: Int = 10
    // 做错后要减去多少分
    var wrongScore = 0
    // 减分倍数
//    var wrongRate = 1

    /// 是否已掌握 [用于双倍扣分，和 P3时跳过s1和s4]
    var mastered: Bool = false

    //MARK: - 以下几个属性用于本地记录进度时使用
    /// 是否根据得分选择题型
//    var isCareScore: Bool = false
    
//    var isBackup: Bool = false
    
    // 是否为新学单词
//    var isNewWord: Bool = false
    
//    var group: Int = 0
    
    /// 第几步
//    var step: Int = 0

    /// 状态
    var status: YXStepStatus = .normal

    /// 当前答题错误次数
    var wrongCount: Int = 0
        
    /// 在当前轮中，是否已经完成，（当前轮完成后，不是删除数据，而且是改变状态为true）
//    var isCurrentTurnFinish: Bool = false

//    未学完的Step数量
//    var unfinishStepCount = 0
    
    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
        
    mutating func mapping(map: Map) {
        type     <- (map["type"], EnumTransform<YXQuestionType>())
        wordId   <- map["word_id"]
        word     <- map["word"]
        question <- map["question"]
        option   <- map["option"]
        answers  <- map["answer_list"]
        score    <- map["score"]
//        mastered <- map["mastered"]
//
//        isCareScore <- map["is_care_score"]
//        isBackup    <- map["is_backup"]
//        isNewWord   <- map["is_new_word"]
//        step       <- map["step"]
    }
    
}

