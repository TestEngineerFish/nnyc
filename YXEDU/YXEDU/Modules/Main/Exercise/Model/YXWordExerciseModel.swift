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
    var score: Int = 10
        
    //MARK: - 以下几个属性用于本地记录进度时使用
    /// 是否根据得分选择题型
    var isCareScore: Bool = false
    
    var isNewWord: Bool = false
    
    /// 第几步
    var step: Int = 0
    /// 对错
    var isRight: Bool?
    
    /// 是否继续做
    var isContinue: Bool?
        
    // 做完
    var isFinish: Bool = false
        
    /// 在当前轮中，是否已经完成，（当前轮完成后，不是删除数据，而且是改变状态为true）
    var isCurrentTurnFinish: Bool = false
    

    init() {}
    
    init?(map: Map) {
        self.mapping(map: map)
    }
        
    mutating func mapping(map: Map) {
        type     <- map["type"]
        word     <- map["word"]
        question <- map["question"]
        option   <- map["option"]
        answers  <- map["answer_list"]
        score    <- map["score"]
                
        isCareScore <- map["is_care_score"]
        isNewWord <- map["is_new_word"]
        
        step <- map["step"]
        isRight <- map["is_right"]
        isContinue <- map["is_continue"]
        isFinish <- map["is_finish"]
        isCurrentTurnFinish <- map["is_current_turn_finish"]
        
    }
    
}



/// 单词的训练步骤
struct YXWordStepsModel: Mappable {
    
    var wordId: Int = 0
    var exerciseSteps: [[YXWordExerciseModel]] = []
    var backupExerciseStep: [String : YXWordExerciseModel] = [:]
    
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
            let stepArray: [YXWordExerciseModel] = []
            exerciseSteps.append(stepArray)
        }
    }
}


struct YXWordBackupTransform: TransformType {
    
    typealias Object = [Int : YXWordExerciseModel]
    typealias JSON = String

    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> [Int : YXWordExerciseModel]? {
        if let str = value as? String, let data = str.data(using: .utf8) {
            let d = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Int : YXWordExerciseModel] ?? [:]
            return d
        }
        return nil
    }
    
    func transformToJSON(_ value: [Int : YXWordExerciseModel]?) -> String? {
        if let data = value, let d = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
//            NSJSONWritingPrettyPrinted
            return String.init(data: d, encoding: .utf8)
        }
        return nil
    }
}

