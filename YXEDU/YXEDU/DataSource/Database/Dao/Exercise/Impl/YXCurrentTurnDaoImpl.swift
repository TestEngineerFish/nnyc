//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXCurrentTurnDaoImpl: YXBaseExerciseDaoImpl, YXCurrentTurnDao {
    
    func insertCurrentTurn(study id: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.insertTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }

    func nextTurnHasN3Question(study id: Int) -> Bool {
        var hasN3Type = false
        let sql = YYSQLManager.CurrentTurnSQL.nextTurnHasN3Type.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return hasN3Type
        }
        if result.next() {
            hasN3Type = result.bool(forColumn: "hasN3Type")
        }
        return hasN3Type
    }

    func insertAllN3Step(study id: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.insertAllN3.rawValue
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
        return result
    }

    func selectExercise(study id: Int) -> YXExerciseModel? {
        let sql = YYSQLManager.CurrentTurnSQL.selectAllStep.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id, 1]) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self._createExercise(rs: result)
        }
        result.close()
        return exercise
    }

    
    func selectAllExercise(study id: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectAllStep.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id, 10000]) else {
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
    
    func selectTurnFinishStatus(study id: Int) -> Bool {
        var finished = true
        let sql = YYSQLManager.CurrentTurnSQL.selectTurnFinishStatus.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return finished
        }
        if result.next() {
            finished = result.bool(forColumn: "finish")
        }
        result.close()
        return finished
    }
    
    func updateExerciseFinishStatus(step id: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.updateFinish.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }
    
    func deleteCurrentTurn(study id: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.deleteCurrentTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
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
