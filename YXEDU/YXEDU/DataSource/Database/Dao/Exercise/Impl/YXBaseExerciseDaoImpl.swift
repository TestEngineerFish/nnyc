//
//  YXBaseExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import FMDB


class YXBaseExerciseDaoImpl: YYDatabase {
    
    func _createExercise(rs: FMResultSet) ->YXExerciseModel {
        var model = YXExerciseModel()
        model.eid           = Int(rs.int(forColumn: "exercise_id"))
        model.stepId        = Int(rs.int(forColumn: "step_id"))
        model.wordId        = Int(rs.int(forColumn: "word_id"))
        model.type          = YXQuestionType(rawValue: rs.string(forColumn: "question_type") ?? "") ?? .none
        model.status        = YXStepStatus.getStatus(Int(rs.int(forColumn: "status")))
        
        // 单词
        model.word          = YXWordModel()
        model.word?.wordId  = Int(rs.int(forColumn: "word_id"))
        model.word?.bookId  = Int(rs.int(forColumn: "book_id"))
        model.word?.unitId  = Int(rs.int(forColumn: "unit_id"))
        model.word?.word    = rs.string(forColumn: "word")
        
        // 问题
        if let json = rs.string(forColumn: "question") {
            model.question = YXExerciseQuestionModel(JSONString: json)
        }
        // 选项
        if let json = rs.string(forColumn: "question_option") {
            model.option = YXExerciseOptionModel(JSONString: json)
        }
        if let operateJson = rs.string(forColumn: "operate") {
            model.operate = YXExerciseOperateModel(JSONString: operateJson)
        }
        // 跳转规则
        if let ruleJson = rs.string(forColumn: "rule") {
            model.ruleModel = YXExerciseRuleModel(JSONString: ruleJson)
        }
                
        return model
    }
}
