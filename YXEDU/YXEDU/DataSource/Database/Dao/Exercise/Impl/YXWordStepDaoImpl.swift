//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YXBaseExerciseDaoImpl, YXWordStepDao {
    
    func selectCurrentGroup(studyId: Int) -> Int? {
        var step: Int?
        let sql = YYSQLManager.WordStepSQL.selectCurrentGroup.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return step
        }
        if result.next() {
            step = Int(result.int(forColumn: "current_group"))
        }
        result.close()
        return step
    }
    
    func selectUnFinishMinStep(studyId: Int, group: Int) -> Int? {
        var step: Int?
        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinStepByTurn.rawValue
        let params = [studyId, group]                      
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return step
        }
        if result.next() {
            step = Int(result.int(forColumn: "step"))
        }
        result.close()
        return step
    }
    
    func selectWordStepModel(studyId: Int, wordId: Int, step: Int) -> YXExerciseModel? {
        var exercise: YXExerciseModel?
        let sql = YYSQLManager.WordStepSQL.selectWordStep.rawValue
        let params = [studyId, wordId, step]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return exercise
        }
        if result.next() {
            exercise            = self._createExercise(rs: result)
            exercise?.mastered  = result.bool(forColumn:"mastered")
        }
        result.close()
        return exercise
    }

    
    func selectOriginalWordStepModelByBackup(studyId: Int, wordId: Int, step: Int) -> YXExerciseModel? {
        var exercise: YXExerciseModel?
        let sql = YYSQLManager.WordStepSQL.selectOriginalWordStepModelByBackup.rawValue
        let params = [studyId, wordId, step]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return exercise
        }
        if result.next() {
            exercise            = self._createExercise(rs: result)
            exercise?.mastered  = result.bool(forColumn:"mastered")
        }
        result.close()
        return exercise
    }
    
    func insertWordStep(study recordId: Int, exerciseModel: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.insertWordStep.rawValue
        
        let params: [Any] = [
            recordId,
            exerciseModel.eid,
            exerciseModel.wordId as Any,
            exerciseModel.word?.bookId as Any,
            exerciseModel.word?.unitId as Any,
            exerciseModel.type.rawValue,
            exerciseModel.question?.toJSONString() as Any,
            exerciseModel.option?.toJSONString() as Any,
            exerciseModel.score,
            exerciseModel.isCareScore,
            exerciseModel.step,
            exerciseModel.isBackup,
            exerciseModel.group,
        ]
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func updateStep(exerciseModel: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updateWordStep.rawValue
        let params: [Any] = [
            exerciseModel.status.rawValue,
            exerciseModel.status == .wrong ? 1 : 0,
            exerciseModel.eid,
            exerciseModel.step
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getReportSteps(with model: YXExerciseModel) -> [String:Any] {
        let sql = YYSQLManager.WordStepSQL.selsetSteps.rawValue
        let params: [Any] = [model.eid]
        var dict = [String:Any]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return dict
        }
        while result.next() {
            let step       = Int(result.int(forColumn: "step"))
            let stepResult = Int(result.int(forColumn: "wrong_count")) == 0
            if step != 0 {
                dict["\(step)"] = stepResult
            }
        }
        result.close()
        return dict
    }

    func skipStep1_4(exercise model: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.skipStep1_4.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [model.eid])
    }

    func getStep1_4Count(exercise id: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.WordStepSQL.selectStep_4Count.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return count
        }
        if result.next() {
            count = Int(result.int(forColumn: "count"))
        }
        result.close()
        return count
    }

    func updatePreviousWrongStatus(studyId: Int) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updatePreviousWrongStatus.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
    }


    func deleteStep(with model: YXExerciseModel) {
        let sql = YYSQLManager.WordStepSQL.deleteStep.rawValue
        let score = model.mastered ? 0 : 7
        let params: [Any] = [model.eid, model.step, score]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func deleteStepWithStudy(study id: Int) -> Bool {
        let sql = YYSQLManager.WordStepSQL.deleteStepWithStudy.rawValue
        let params: [Any] = [id]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
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
    func selecteWordScore(exercise model: YXExerciseModel) -> Int {
        return 10
    }

    func getStepStatus(exercise model: YXExerciseModel) -> YXStepStatus {
        var status = YXStepStatus.normal
        let sql = YYSQLManager.WordStepSQL.selectInfo.rawValue
        let params = [model.eid, model.step]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return status
        }
        if result.next() {
            let statusInt = Int(result.int(forColumn: "status"))
            status = YXStepStatus.getStatus(statusInt)
        }
        result.close()
        return status
    }

    func getExerciseWrongAmount(exercise id: Int) -> Int {
        var amount = 0
        let sql = YYSQLManager.WordStepSQL.selectExerciseStep.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return amount
        }
        while result.next() {
            let count = Int(result.int(forColumn: "wrong_count"))
            amount += count
        }
        result.close()
        return amount
    }
}
