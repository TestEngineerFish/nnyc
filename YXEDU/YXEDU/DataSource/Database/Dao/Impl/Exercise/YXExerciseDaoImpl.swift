//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseDaoImpl: YYDatabase, YXExerciseDao {
    
    func insertExercise(type: YXExerciseRuleType, planId: Int? = nil, exerciseModel: YXWordExerciseModel) -> Bool {
        
        let sql = YYSQLManager.ExerciseSQL.insertExercise.rawValue
        let params: [Any] = [
            type.rawValue,
            exerciseModel.dataType.rawValue,
            exerciseModel.word?.wordId as Any,
            exerciseModel.word?.word as Any,
            exerciseModel.word?.bookId as Any,
            exerciseModel.word?.unitId as Any,
            planId as Any,
            exerciseModel.isNewWord,
            exerciseModel.unfinishStepCount
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    @discardableResult
    func deleteExpiredExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteExpiredExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func deleteAllExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteAllExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
}
