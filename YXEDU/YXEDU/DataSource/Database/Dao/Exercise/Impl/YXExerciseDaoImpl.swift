//
//  YXExerciseDaoImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import FMDB

class YXExerciseDaoImpl: YYDatabase, YXExerciseDao {
    
    func insertExercise(learn config: YXLearnConfig, rule: YXExerciseRuleType, study recordId: Int, exerciseModel: YXExerciseModel) -> Int {
        
        let sql = YYSQLManager.ExerciseSQL.insertExercise.rawValue
        let params: [Any] = [
            recordId,
            rule.rawValue,
            config.learnType.rawValue,
            exerciseModel.word?.wordId as Any,
            exerciseModel.word?.word as Any,
            exerciseModel.word?.bookId as Any,
            exerciseModel.word?.unitId as Any,
            config.planId as Any,
            exerciseModel.isNewWord,
            exerciseModel.unfinishStepCount
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params) ? Int(self.wordRunner.lastInsertRowId) : 0
    }

    func updateExercise(exercise model: YXExerciseModel) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateExercise.rawValue
        let params: [Any] = [
            model.mastered ? 1 : 0,
            model.score,
            model.unfinishStepCount,
            model.eid]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getAllExercise(learn config: YXLearnConfig) -> [YXExerciseModel] {
        var modelList = [YXExerciseModel]()
        let sql = YYSQLManager.ExerciseSQL.getAllExercise.rawValue
        let params: [Any] = [
            config.learnType.rawValue,
            config.planId ?? 0]
        let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params)
        while result?.next() == .some(true) {
            if let model = self.transformModel(result: result) {
                modelList.append(model)
            }
        }
        return modelList
    }

    func deleteExercise(study id: Int) {
        let sql = YYSQLManager.ExerciseSQL.deleteExerciseWithStudy.rawValue
        let params: [Any] = [id]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    @discardableResult
    func deleteExpiredExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteExpiredExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func deleteAllExercise() -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteAllExercise.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }

    // MARK: ==== Tools ====
    /// 转换练习模型
    private func transformModel(result: FMResultSet?) -> YXExerciseModel? {
        guard let result = result else {
            return nil
        }
        var model = YXExerciseModel()
        model.eid          = Int(result.int(forColumn: "exercise_id"))
        model.learnType     = YXLearnType.transform(raw: Int(result.int(forColumn: "learn_type")))
        model.word         = YXWordModel()
        model.word?.word   = result.string(forColumn: "word")
        model.word?.wordId = Int(result.int(forColumn: "word_id"))
        model.word?.bookId = Int(result.int(forColumn: "book_id"))
        model.word?.unitId = Int(result.int(forColumn: "unit_id"))
        model.mastered     = result.bool(forColumn:"mastered")
        model.score        = Int(result.int(forColumn: "score"))
        model.wrongCount   = Int(result.int(forColumn: "wrong_count"))
        model.isNewWord    = result.bool(forColumn: "is_new")
        model.unfinishStepCount = Int(result.int(forColumn: "unfinish_count"))
        return model
    }
}
