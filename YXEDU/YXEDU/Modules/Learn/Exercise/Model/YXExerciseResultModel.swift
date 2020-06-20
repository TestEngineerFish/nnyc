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
    var newWordCount: Int           = 0
    var reviewWordCount: Int        = 0
    var wordList: [YXExerciseWordModel] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        type            <- (map["review_type"], YXExerciseDataTypeTransform())
        newWordCount    <- map["new_word_num"]
        reviewWordCount <- map["review_word_num"]
        wordList        <- map["rule_list"]
    }
}

struct YXExerciseWordModel: Mappable {
    var wordModel: YXWordModel?
    var startStep: String = ""
    var stepModelList: [YXExerciseStepModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        wordModel     <- map["word"]
        startStep     <- map["start"]
        stepModelList <- map["list"]
    }
}
struct YXExerciseStepModel: Mappable {
    var step: String = ""
    var questionType: YXQuestionType = .none
    var questionModel: YXExerciseQuestionModel?
    var operateModel: YXExerciseOperateModel?
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

struct YXExerciseQuestionModel: Mappable {
    var word: String = ""
    var extendModel: YXExerciseQuestionExtendModel?
    var option: YXExerciseOptionModel?
    init?(map: Map) {}
    init() {}
    mutating func mapping(map: Map) {
        word        <- map["word"]
        extendModel <- map["ext"]
        option      <- map["option"]
    }
}

struct YXExerciseQuestionExtendModel: Mappable {
    var optionItemsCount: Int = 0
    var row: Int              = 0
    var column: Int           = 0
    init?(map: Map) {}
    init() {}
    mutating func mapping(map: Map) {
        optionItemsCount <- map["select_item_num"]
        row              <- map["line_row"]
        column           <- map["line_column"]
    }
}

struct YXExerciseOperateModel: Mappable {
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

