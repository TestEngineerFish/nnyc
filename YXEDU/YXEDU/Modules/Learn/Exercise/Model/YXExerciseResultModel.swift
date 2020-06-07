//
//  YXExerciseResultModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/8.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper


/// 当天学习数据总模型
struct YXExerciseResultModel: Mappable {
    var type: YXLearnType     = .base
    var ruleType: YXExerciseRule = .p0
    var bookId: Int?
    var unitId: Int?
    var newWordIds: [Int]?
    var reviewWordIds: [Int]?
    var steps: [[YXExerciseModel]]?
    var groups: [[[YXExerciseModel]]] = []
    var scoreRule: [YXScoreRuleModel] = []
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        type          <- (map["review_type"], YXExerciseDataTypeTransform())
        ruleType      <- (map["learn_rule"], YXExerciseRuleTransform())
        bookId        <- map["book_id"]
        unitId        <- map["unit_id"]
        newWordIds    <- map["new_word_list"]
        reviewWordIds <- map["review_word_list"]

        steps         <- map["step_list"]
//        groups        <- map["group_list"]
        scoreRule     <- map["step_score"]
        
        // Mappable库不能解析三维数组，手动解析
        parserGroup(map: map["group_list"])

    }
    
    
    /// 解析分组数据，Mappable库不能解析三维数组，手动解析
    /// - Parameter list:
    mutating func parserGroup(map: Map) {
        guard let groupAnyArray = map.currentValue as? Array<Any> else {
            return
        }
        
        for groupAny in groupAnyArray {
            // 单个group的原始数据
            guard let groupData = groupAny as? Array<Any> else {
                continue
            }
            var group = [[YXExerciseModel]]()
            for stepAny in groupData {
                // 单个step的原始数据
                guard let stepData = stepAny as? Array<Any> else {
                    continue
                }
                var step = [YXExerciseModel]()
                for subStep in stepData {
                    if let subStepJson = subStep as? [String:Any], let exerciseModel = YXExerciseModel(JSON: subStepJson) {
                        step.append(exerciseModel)
                    }
                }
                group.append(step)
            }
            self.groups.append(group)
        }
    }
}


/// 问题数据模型
struct YXExerciseQuestionModel: Mappable {

    var wordId: Int? = -1
    var word: String?
    var itemCount: Int = 4
    var column: Int = 0
    var row: Int = 0
    var extend: YXExerciseQuestionExtendModel?

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
        extend    <- map["ext"]
    }
}

struct YXExerciseQuestionExtendModel: Mappable {
    
//    var isNewWord: Bool = false
//    var isOldOrEmptyImage: Bool = false
    var power: Int = 0 // 能力值
    init() {}
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
//        isNewWord              <- map["is_new_word"]
//        isOldOrEmptyImage      <- map["is_old_img_or_no_img"]
        power                  <- map["last_score"]
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
        firstItems  <- map["first"]
        secondItems <- map["second"]
    }
}


struct YXOptionItemModel: Mappable {
    var optionId: Int    = -1
    var content: String?
    var isDisable: Bool = false
    var isWrong: Bool = false

    init() {}
            
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        optionId <- map["option_id"]
        content <- map["content"]
    }
}



/// 扣分规则
struct YXScoreRuleModel: Mappable {
    /// 扣几分
    var score: Int  = 3
    /// 扣分倍数
    var rate: Int   = 1
    /// 第几步
    var step: Int   = 1

    init() {}
            
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        score <- map["score"]
        step  <- map["rate"]
        step  <- map["rate"]
    }
}


struct YXExerciseDataTypeTransform: TransformType {
        
    typealias Object = YXLearnType
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> YXLearnType? {
        if let v = value as? Int, let state = YXLearnType(rawValue: v) {
            return state
        }
        return .base
    }
    
    func transformToJSON(_ value: YXLearnType?) -> Int? {
        return value?.rawValue
    }

}


struct YXExerciseRuleTransform: TransformType {
        
    typealias Object = YXExerciseRule
    typealias JSON = String
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> YXExerciseRule? {
        if let v = value as? String, let rule = YXExerciseRule(rawValue: v.uppercased()) {
            return rule
        }
        return .p0
    }
    
    func transformToJSON(_ value: YXExerciseRule?) -> String? {
        return value?.rawValue
    }

}
