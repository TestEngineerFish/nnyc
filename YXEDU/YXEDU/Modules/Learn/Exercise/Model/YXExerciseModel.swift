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
    /// 练习单词表ID
    var eid: Int = 0
    /// 练习步骤表ID
    var stepId: Int = 0
    /// 做题后事件规则对象
    var ruleModel: YXExerciseRuleModel?
    /// 题型
    var type: YXQuestionType = .none
    /// 学习类型
    var learnType: YXLearnType = .base
    /// 对应的单词数据
    var wordId: Int = 0
    /// 单词
    var word: YXWordModel?
    /// N3题列表
    var n3List: [YXExerciseModel] = []
    /// 问题
    var question: YXExerciseQuestionModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 扩展
    var operate: YXNewExerciseOperateModel?
    /// 答案
    var answers: [Int]?
    // 做错后要减去多少分
    var wrongScore = 0
    /// 是否已掌握（新学）
//    var mastered: Bool = false


    /// 状态
    var status: YXStepStatus = .normal

    /// 当前答题错误次数(不用做数据库存储，仅用做更新状态判断，因为可能当前题重复做错，最后一次做对，但是结果需要表示未做错)
    var wrongCount: Int = 0
    
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
    }
    
}

