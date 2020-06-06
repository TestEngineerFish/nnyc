//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXCurrentTurnDaoImpl: YYDatabase, YXCurrentTurnDao {
    func insertCurrentTurn() -> Bool {
        return false
    }
    
    func selectExercise() -> YXExerciseModel? {
        
        
        
        return nil
    }
    
    func selectExercise(step: Int, type: YXQuestionType) -> [YXExerciseModel] {
        return []
    }
    
    func selectBackupExercise(exerciseId: Int, step: Int) -> YXExerciseModel? {
        return nil
    }
    
    
    func selectConnectionType() -> (YXQuestionType, Int)? {
        let sql = YYSQLManager.CurrentTurnSQL.selectConnectionType.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return nil
        }
        if result.next() {
            let type = YXQuestionType(rawValue: result.string(forColumn: "question_type") ?? "") ?? YXQuestionType.none
            let step = Int(result.int(forColumn: "step"))
            result.close()
            
            return (type, step)
        }
        result.close()
        return nil
    }
    
    func selectTurnFinishStatus() -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.selectTurnFinishStatus.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return true
        }
        if result.next() {
            let finish = result.bool(forColumn: "finish")
            result.close()
            return finish
        }
        result.close()
        return true
    }
    
    func updateExerciseFinishStatus(stepId: Int) -> Bool {
        return false
    }
    
    func deleteCurrentTurn() -> Bool {
        return false
    }
    
    
}
