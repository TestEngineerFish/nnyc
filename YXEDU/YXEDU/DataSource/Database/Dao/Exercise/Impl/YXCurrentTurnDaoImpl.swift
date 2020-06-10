//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXCurrentTurnDaoImpl: YXBaseExerciseDaoImpl, YXCurrentTurnDao {
    
    func insertCurrentTurn(studyId: Int, group: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.insertTurn.rawValue
        let params = [studyId, studyId, group]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }
    
    
    func selectExercise(studyId: Int) -> YXExerciseModel? {
        let sql = YYSQLManager.CurrentTurnSQL.selectExercise.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId, 1]) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self._createExercise(rs: result)
        }
        result.close()
        return exercise
    }

    
    func selectAllExercise(studyId: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectExercise.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId, 10000]) else {
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
    
    func selectCurrentTurn(studyId: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectCurrentTurn.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return []
        }
        var modelList = [YXExerciseModel]()
        while result.next() {
            var model = self._createExercise(rs: result)
            model.isCurrentTurnFinish = result.bool(forColumn: "finish")
            modelList.append(model)
        }
        result.close()
        return modelList
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

    func deleteAllExpiredTurn() -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.deleteAllTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    
    
}
