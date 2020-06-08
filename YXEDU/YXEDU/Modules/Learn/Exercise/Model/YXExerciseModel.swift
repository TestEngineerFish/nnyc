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
    
    // 题型
    var type: YXQuestionType = .none
    // 学习类型
    var learnType: YXLearnType = .base
        
    /// 对应的单词数据
    var wordId: Int = 0
    var word: YXWordModel?
    
    /// 问题（使用 word 模型）
    var question: YXExerciseQuestionModel?
    /// 选项
    var option: YXExerciseOptionModel?
    /// 答案
    var answers: [Int]?
    /// 得分【这个字段有歧义，开始是当题型分数来使用的，后面做了答题分数在用，后面要改】
    var score: Int = 10
    // 做错后要减去多少分
    var wrongScore = 0
    // 减分倍数
    var wrongRate = 1

    /// 代移除
    var questionTypeScore: Int = 0  // 题型分[已掌握7分，不认识0分]
    /// 是否已掌握 [用于双倍扣分，和 P3时跳过s1和s4]
    var mastered: Bool = false

    //MARK: - 以下几个属性用于本地记录进度时使用
    /// 是否根据得分选择题型
    var isCareScore: Bool = false
    
    var isBackup: Bool = false
    
    // 是否为跟读流程
    var isListenAndRepeat = false
    // 是否为新学单词【跟读和训练】
    var isNewWord: Bool = false
    
//    var wordType: YXExerciseWordType = .new
    var group: Int = 0
    
    /// 第几步
    var step: Int = 0
    /// 对错
    var isRight: Bool?
    /// 状态
    var status: YXStepStatus = .normal
    
    /// 是否继续做
    var isContinue: Bool?
        
    // 做完
    var isFinish: Bool = false

    /// 答题结果，是否正确
    var result: Bool?
    /// 当题错误次数
    var wrongCount: Int = 0
        
    /// 在当前轮中，是否已经完成，（当前轮完成后，不是删除数据，而且是改变状态为true）
    var isCurrentTurnFinish: Bool = false

//    未学完的Step数量
    var unfinishStepCount = 0
    
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
        mastered <- map["mastered"]

        isCareScore <- map["is_care_score"]
        isBackup    <- map["is_backup"]
        isNewWord   <- map["is_new_word"]
        isListenAndRepeat <- map["is_listen_and_repeat"]
        
        step       <- map["step"]
        isRight    <- map["is_right"]
        isContinue <- map["is_continue"]
        isFinish   <- map["is_finish"]
        isCurrentTurnFinish <- map["is_current_turn_finish"]
        
    }
    
}




/// 单词的训练步骤
struct YXWordStepsModel: Mappable {
    
    var wordId: Int = 0
    // 数组中包含Step1-4的数组，如果要出0-7的分值题，则里面的数组包含两个练习对象，一般都是一个练习对象
    var exerciseSteps: [[YXExerciseModel]] = []
    var backupExerciseStep: [String : YXExerciseModel] = [:]
    
    init() {
        self.initSteps()
    }
    
    init?(map: Map) {
        self.initSteps()
        self.mapping(map: map)
    }
    mutating func mapping(map: Map) {
        wordId                  <- map["word_id"]
        exerciseSteps           <- map["exercise_step_list"]
        backupExerciseStep      <- map["backup_exercise_step_map"] //(, YXWordBackupTransform())
    }
    
    private mutating func initSteps() {
        for _ in 0..<4 {
            let stepArray: [YXExerciseModel] = []
            exerciseSteps.append(stepArray)
        }
    }
}


struct YXWordBackupTransform: TransformType {
    
    typealias Object = [Int : YXExerciseModel]
    typealias JSON = String

    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> [Int : YXExerciseModel]? {
        if let str = value as? String, let data = str.data(using: .utf8) {
            let d = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Int : YXExerciseModel] ?? [:]
            return d
        }
        return nil
    }
    
    func transformToJSON(_ value: [Int : YXExerciseModel]?) -> String? {
        if let data = value, let d = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
//            NSJSONWritingPrettyPrinted
            return String.init(data: d, encoding: .utf8)
        }
        return nil
    }
}

