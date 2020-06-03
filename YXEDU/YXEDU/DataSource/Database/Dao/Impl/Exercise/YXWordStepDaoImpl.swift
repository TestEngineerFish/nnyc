//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YYDatabase, YXWordStepDao {
    
    func selectExercise(type: Int) -> YXWordExerciseModel? {
        return nil
    }
    
    func selectBackupExercise(wordId: Int, step: Int) -> YXWordExerciseModel? {
        return nil
    }
    
    
    func insertWordStep(type: YXExerciseRuleType, exerciseModel: YXWordExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.insertWordStep.rawValue
        
        let params: [Any] = [
            exerciseModel.eid,
            exerciseModel.word?.bookId as Any,
            exerciseModel.word?.unitId as Any,
            exerciseModel.type.rawValue,
            exerciseModel.question?.wordId as Any,
            exerciseModel.question?.word as Any,
            exerciseModel.question?.itemCount as Any,
            exerciseModel.question?.row as Any,
            exerciseModel.question?.column as Any,
            exerciseModel.question?.extend?.power as Any,
            exerciseModel.score,
            exerciseModel.isCareScore,
            exerciseModel.step,
            exerciseModel.isBackup,
            exerciseModel.wrongScore,
            exerciseModel.wrongMultiple
        ]
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }
    
    func updateExercise(exerciseModel: YXWordExerciseModel) -> Bool {
        return true
    }
    
//    func deleteExercise() -> Bool {
//        return true
//    }
    
    func selectExerciseProgress() -> YXExerciseProgress {
        return .reported
    }
    

    
    @discardableResult
    func deleteExpiredWordStep() -> Bool {
        let sql = YYSQLManager.WordStepSQL.deleteExpiredWordStep.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func deleteAllWordStep() -> Bool {
        let sql = YYSQLManager.WordStepSQL.deleteAllWordStep.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }

    /// 查询单词得分
    func selecteWordScore(exercise model: YXWordExerciseModel) -> Int {
        return 10
    }
}
