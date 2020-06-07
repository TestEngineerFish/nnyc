//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YYDatabase, YXWordStepDao {
    
    
//    func selectExercise(type: Int) -> YXExerciseModel? {
//        return nil
//    }
//
//    func selectBackupExercise(wordId: Int, step: Int) -> YXExerciseModel? {
//        return nil
//    }
    
    
    func selectMinUnFinishStep(studyId: Int, group: Int) -> Int? {
        let sql = YYSQLManager.CurrentTurnSQL.selectConnectionType.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return nil
        }
        if result.next() {
            let step = Int(result.int(forColumn: "step"))
            result.close()
            
            return step
        }
        result.close()
        return nil
    }
    
    func insertWordStep(type: YXExerciseRuleType, study recordId: Int, exerciseModel: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.insertWordStep.rawValue
        
        let params: [Any] = [
            recordId,
            exerciseModel.eid,
            exerciseModel.wordId as Any,
            exerciseModel.word?.bookId as Any,
            exerciseModel.word?.unitId as Any,
            exerciseModel.type.rawValue,            
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
            exerciseModel.wrongRate,
            exerciseModel.group,
        ]
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func updateStep(exerciseModel: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.updateWordStep.rawValue
        let params: [Any] = [
            exerciseModel.status.rawValue,
            exerciseModel.wrongCount,
            exerciseModel.eid,
            exerciseModel.step,
            exerciseModel.score]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getSteps(with model: YXExerciseModel) -> ([String:Any], Int) {
        let sql = YYSQLManager.WordStepSQL.selsetSteps.rawValue
        let params: [Any] = [model.eid]
        var dict = [String:Any]()
        var wrongCount = 0
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params){
            while result.next() {
                let step = Int(result.int(forColumn: "step"))
                let stepResult = Int(result.int(forColumn: "status")) == 1
                wrongCount += Int(result.int(forColumn: "wrong_count"))

                dict["\(step)"] = stepResult
            }
        }
        return (dict, wrongCount)
    }

    func selectExerciseProgress() -> YXExerciseProgress {
        return .none
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
}
