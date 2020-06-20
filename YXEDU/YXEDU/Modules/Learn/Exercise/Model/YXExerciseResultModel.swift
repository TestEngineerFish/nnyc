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
    var type: YXLearnType           = .base
    var ruleType: YXExerciseRule    = .p0
    var newWordCount: Int           = 0
    var reviewWordCount: Int        = 0
    var wordList: [YXNewExerciseWordModel] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        type            <- (map["review_type"], YXExerciseDataTypeTransform())
        ruleType        <- (map["learn_rule"], YXExerciseRuleTransform())
        newWordCount    <- map["new_word_num"]
        reviewWordCount <- map["review_word_num"]
        wordList        <- map["rule_list"]
    }
}

struct YXNewExerciseWordModel: Mappable {
    var wordModel: YXWordModel?
    var startStep: String = ""
    var stepModelList: [YXNewExerciseStepModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        wordModel     <- map["word"]
        startStep     <- map["start"]
        stepModelList <- map["list"]
    }
}
struct YXNewExerciseStepModel: Mappable {
    var step: String = ""
    var questionType: YXQuestionType = .none
    var questionModel: YXNewExerciseQuestionModel?
    var operateModel: YXNewExerciseOperateModel?
    var ruleModel: YXExerciseRuleModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        step          <- map["step_type"]
        questionType  <- (map["question_type"], EnumTransform<YXQuestionType>())
        questionModel <- map["question"]
        operateModel  <- map["operate"]
        ruleModel     <- map["rule"]
    }
}

struct YXNewExerciseQuestionModel: Mappable {
    var word: String = ""
    var extendModel: YXNewExerciseQuestionExtendModel?
    var option: String = ""
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        word        <- map["word"]
        extendModel <- map["ext"]
        option      <- map["option"]
    }
}

struct YXNewExerciseQuestionExtendModel: Mappable {
    var optionItemsCount: Int = 0
    var row: Int              = 0
    var column: Int           = 0
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        optionItemsCount <- map["select_item_num"]
        row              <- map["line_row"]
        column           <- map["line_column"]
    }
}

struct YXNewExerciseOperateModel: Mappable {
    /// 错误是扣的分
    var errorScore: Int     = 0
    /// 跟读是否允许打断
    var canNextAction: Bool = false
    /// 做对是否显示详情
    var showDetail: Bool    = false
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        errorScore    <- map["error_score"]
        canNextAction <- map["click_next_action"]
        showDetail    <- map["force_show_info"]
    }
}

struct YXExerciseRuleModel: Mappable {
    var errorStep: String?
    var rightStep: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        errorStep <- map["1"]
        rightStep <- map["2"]
    }

    func getNextStep(isRight: Bool) -> String {
        if isRight {
            return rightStep ?? "END"
        } else {
            return errorStep ?? "END"
        }
    }
}

// MARK: ==== Old ===


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
    
    /// 是否显示单词详情页
    var isShowWordDetail: YXShowWordDetailType = .none
    
    /// 新学时，可以点击《下一个》
    var allowClickNext = false
    
    init() {}
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        power                  <- map["last_score"]
        isShowWordDetail       <- (map["show_info_action"], EnumTransform<YXShowWordDetailType>())
        allowClickNext         <- map["click_next_action"]
        
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

