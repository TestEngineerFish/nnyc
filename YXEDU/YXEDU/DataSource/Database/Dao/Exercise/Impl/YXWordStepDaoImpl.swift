//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordStepDaoImpl: YYDatabase, YXWordStepDao {
    
    func selectUnFinishMinStep(studyId: Int, group: Int) -> Int? {
        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinStep.rawValue
        let params = [studyId, studyId, group]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
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
    
    func selectUnFinishMinStep(studyRecord: YXStudyRecordModel) -> Int? {
        let sql = YYSQLManager.WordStepSQL.selectUnfinishMinStepByTurn.rawValue
        let params = [studyRecord.studyId,
                      studyRecord.currentTurn,
                      studyRecord.currentGroup]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
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
            exerciseModel.questionTypeScore]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getSteps(with model: YXExerciseModel) -> [String:Any] {
        let sql = YYSQLManager.WordStepSQL.selsetSteps.rawValue
        let params: [Any] = [model.eid]
        var dict = [String:Any]()
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params){
            while result.next() {
                let step        = Int(result.int(forColumn: "step"))
                let stepResult  = Int(result.int(forColumn: "status")) == 2
                dict["\(step)"] = stepResult
            }
        }
        return dict
    }

    func skipStep1_4(exercise model: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.WordStepSQL.skipStep1_4.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [model.eid])
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
