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
//        var step: Int?
//        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinGroup.rawValue
//        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
//            return step
//        }
//        if result.next() {
//            step = Int(result.int(forColumn: "current_group"))
//        }
//        result.close()
//        return step
        return nil
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

    func updateStep(exercise model: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updateWordStep.rawValue
        let params: [Any] = [
            model.status.rawValue,
            model.status == .wrong ? 1 : 0,
            model.stepId
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getReportSteps(with model: YXExerciseModel) -> [String:Bool] {
        let sql    = YYSQLManager.WordStepSQL.selectAllSteps.rawValue
        let params = [model.eid]
        var dict   = [String:Bool]()
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return dict
        }
        while result.next() {
            let step   = result.string(forColumn: "step") ?? ""
            let status = Int(result.int(forColumn: "status"))
            // 未学不上报
            if status == -1 { continue }
            let stepResult: Bool = Int(result.int(forColumn: "wrong_count")) == 0
            dict[step] = stepResult
        }
        result.close()
        return dict
    }

//    func getStepCount(exercise eid: Int, step: Int) -> Int {
//        var amount = 0
//        let sql = YYSQLManager.WordStepSQL.selectStepCount.rawValue
//        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [eid, step]) else {
//            return amount
//        }
//        if result.next() {
//            amount = Int(result.int(forColumn: "count"))
//        }
//        return amount
//    }

//    func updatePreviousWrongStatus(studyId: Int) -> Bool {
//        let sql = YYSQLManager.WordStepSQL.updatePreviousWrongStatus.rawValue
//        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
//    }


    func deleteStep(with model: YXExerciseModel) {
        let sql = YYSQLManager.WordStepSQL.deleteStep.rawValue
        let score = model.mastered ? 7 : 0
        let params: [Any] = [model.eid, 0, score]
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
        let params = [model.eid, 0]
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
        let sql = YYSQLManager.WordStepSQL.selectAllSteps.rawValue
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
