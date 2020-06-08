//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXCurrentTurnDaoImpl: YXBaseExerciseDaoImpl, YXCurrentTurnDao {
    func selectNewTurn(studyId: Int, group: Int) -> [YXCurrentTurnModel] {
        var sql = YYSQLManager.CurrentTurnSQL.selectNewTurn.rawValue
//        let params = [studyId, studyId, group]
        sql = String(format: sql, studyId, studyId, group)
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return []
        }
        var es: [YXCurrentTurnModel] = []
        while result.next() {
            var model = YXCurrentTurnModel()
            model.studyId = studyId
            model.stepId = Int(result.int(forColumn: "step_id"))
            model.step = Int(result.int(forColumn: "step"))
            model.turn = Int(result.int(forColumn: "turn"))
            es.append(model)
        }
        result.close()
        
        return es
        
    }
    
    func insertCurrentTurn(studyId: Int, group: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.insertTurn.rawValue
        let params = [studyId, studyId, group]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func selectCurrentTurn(studyId: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectExercise.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return []
        }
        var modelList = [YXExerciseModel]()
        while result.next() {
            let model = self._createExercise(rs: result)
            modelList.append(model)
        }
        result.close()
        return modelList
    }
    
    func selectExercise(studyId: Int) -> YXExerciseModel? {
        let sql = YYSQLManager.CurrentTurnSQL.selectExercise.rawValue + " limit 1"
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self._createExercise(rs: result)
        }
        result.close()
        return exercise
    }
    
    func selectExercise(studyId: Int, type: YXQuestionType, step: Int, size: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectConnectionExercise.rawValue
        let params: [Any] = [studyId, type.rawValue, step, size]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return []
        }
        var es: [YXExerciseModel] = []
        while result.next() {
            es.append(self._createExercise(rs: result))
        }
        result.close()
        
        return es
    }
    
    func selectBackupExercise(studyId: Int, exerciseId: Int, step: Int) -> YXExerciseModel? {
        let sql = YYSQLManager.WordStepSQL.selectBackupStep.rawValue
        let params = [studyId, exerciseId, step]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self._createExercise(rs: result)
        }
        result.close()
        return exercise
    }
    
    // 暂时没有使用
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
    
    func selectTurnFinishStatus(studyId: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.selectTurnFinishStatus.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
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
        let sql = YYSQLManager.CurrentTurnSQL.updateFinish.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [stepId])
    }
    
    func updateExerciseFinishStatus(studyId: Int, wordId: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.updateFinishByWordId.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId, wordId])
    }
    
    func deleteCurrentTurn(studyId: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.deleteCurrentTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
    }
    
    func deleteExpiredTurn() -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.deleteExpiredTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    
    
}
