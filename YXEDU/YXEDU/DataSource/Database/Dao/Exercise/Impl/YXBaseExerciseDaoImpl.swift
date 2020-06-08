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
        model.step          = Int(rs.int(forColumn: "step"))
        model.status        = YXStepStatus.getStatus(Int(rs.int(forColumn: "status")))
        
        // 单词
        model.word          = YXWordModel()
        model.word?.wordId  = Int(rs.int(forColumn: "word_id"))
        model.word?.bookId  = Int(rs.int(forColumn: "book_id"))
        model.word?.unitId  = Int(rs.int(forColumn: "unit_id"))
        
        // 问题
        if let json = rs.string(forColumn: "question") {
            model.question = YXExerciseQuestionModel(JSONString: json)
        }
        
        // 选项
        if let json = rs.string(forColumn: "option") {
            model.option = YXExerciseOptionModel(JSONString: json)
        }
        
        model.wrongCount    = Int(rs.int(forColumn: "wrong_count"))
        model.isBackup      = rs.bool(forColumn: "backup")
        
        return model
    }
}
