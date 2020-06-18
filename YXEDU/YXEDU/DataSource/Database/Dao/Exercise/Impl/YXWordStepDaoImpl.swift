//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YXBaseExerciseDaoImpl, YXWordStepDao {
    func insertWordStep(study recordId: Int, eid: Int, wordModel: YXWordModel, stepModel: YXNewExerciseStepModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.insertWordStep.rawValue

        let params: [Any] = [
            recordId,
            eid,
            wordModel.wordId as Any,
            wordModel.bookId as Any,
            wordModel.unitId as Any,
            stepModel.questionType.rawValue,
            stepModel.questionModel?.toJSONString() as Any,
            stepModel.operateModel?.toJSONString() as Any,
            stepModel.step,
            stepModel.ruleModel?.toJSONString() as Any,
        ]
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        return result
    }

    func selectCurrentGroup(studyId: Int) -> Int? {
        var step: Int?
        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinGroup.rawValue
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
        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinStep.rawValue
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
    
    
    func selectMinStepWrongCount(studyId: Int, wordId: Int) -> (Int, Int)? {
        let sql = YYSQLManager.WordStepSQL.selectMinStepWrongCount.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId, wordId]) else {
            return nil
        }
        if result.next() {
            let minStep = Int(result.int(forColumn: "min_step"))
            let wrongCount = Int(result.int(forColumn: "wrong_count"))
            result.close()
            return (minStep, wrongCount)
        }
        result.close()
        return nil
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

    func getReportSteps(with model: YXExerciseModel) -> [String:Any?] {
        let sql = YYSQLManager.WordStepSQL.selsetSteps.rawValue
        let params: [Any] = [model.eid]
        var dict = [String:Any]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return dict
        }
        while result.next() {
            let step       = Int(result.int(forColumn: "step"))
            let stepResult: Any? = {
                let status = Int(result.int(forColumn: "status"))
                // 跳过
                if status == 3 {
                    return nil
                } else {
                    return Int(result.int(forColumn: "wrong_count")) == 0
                }
            }()
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

    func getStepCount(exercise eid: Int, step: Int) -> Int {
        var amount = 0
        let sql = YYSQLManager.WordStepSQL.selectStepCount.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [eid, step]) else {
            return amount
        }
        if result.next() {
            amount = Int(result.int(forColumn: "count"))
        }
        return amount
    }

    func updatePreviousWrongStatus(studyId: Int) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updatePreviousWrongStatus.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
    }


    func deleteStep(with model: YXExerciseModel) {
        let sql = YYSQLManager.WordStepSQL.deleteStep.rawValue
        let score = model.mastered ? 7 : 0
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
