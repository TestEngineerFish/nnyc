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
        
        let bookId = exerciseModel.word?.bookId as Any
        let unitId = exerciseModel.word?.unitId as Any
        let learnType = exerciseModel.dataType.rawValue
        let wordId = exerciseModel.word?.wordId as Any
        let questionType = exerciseModel.type.rawValue
        let questionWordId = exerciseModel.question?.wordId as Any
        let questionWordContent = exerciseModel.question?.word as Any
        let questionOptionCount = exerciseModel.question?.itemCount as Any
        let questionRowCount = exerciseModel.question?.row as Any
        let questionRolumnCount = exerciseModel.question?.column as Any
        let questionExtScore = exerciseModel.question?.extend?.power as Any
        let careScore = exerciseModel.isCareScore
        let score = exerciseModel.score
        let step = exerciseModel.step
        let backup = exerciseModel.isBackup
        let answer = exerciseModel.answers?.first as Any
        let wordType = exerciseModel.wordType.rawValue
        
        let params: [Any] = [
            type.rawValue, bookId, unitId, learnType, wordId, questionType, questionWordId, questionWordContent, questionOptionCount,
            questionRowCount, questionRolumnCount, questionExtScore,careScore, score, step, backup, answer, wordType
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
    

    
    
    func deleteExpiredWordStep() -> Bool {
        let sql = YYSQLManager.WordStepSQL.deleteExpiredWordStep.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func deleteAllWordStep() -> Bool {
        let sql = YYSQLManager.WordStepSQL.deleteAllWordStep.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
}
