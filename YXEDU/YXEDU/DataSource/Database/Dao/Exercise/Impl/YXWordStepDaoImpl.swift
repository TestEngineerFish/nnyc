//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YXBaseExerciseDaoImpl, YXWordStepDao {

    func insertWordStep(studyId: Int, exerciseId: Int, wordModel: YXWordModel, stepModel: YXNewExerciseStepModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.insertWordStep.rawValue

        let params: [Any] = [
            studyId,
            exerciseId,
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

    func updateStep(status: YXStepStatus, step id: Int) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updateWordStep.rawValue
        let params: [Any] = [
            status.rawValue,
            status == .wrong ? 1 : 0,
            id
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getReportSteps(exercise id: Int) -> [String:Bool] {
        let sql    = YYSQLManager.WordStepSQL.selectStepsWithExercise.rawValue
        let params = [id]
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

    func getExerciseWrongAmount(exercise id: Int) -> Int {
        var amount = 0
        let sql = YYSQLManager.WordStepSQL.selectStepsWithExercise.rawValue
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
