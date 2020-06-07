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
    
    func getExerciseCount(learn config: YXLearnConfig, includeNewWord: Bool, includeReviewWord: Bool) -> Int {
        var sql = YYSQLManager.ExerciseSQL.getExerciseCount.rawValue
        if includeNewWord && !includeReviewWord {
            // 仅获取新学
            sql += " and is_new = 1"
        } else if !includeNewWord && includeReviewWord {
            // 仅获取复习
            sql += " and is_new = 0"
        } else if !includeNewWord && !includeReviewWord {
            // 都不获取
            return 0
        }
        let params: [Any] = [
            config.learnType.rawValue,
            config.planId,
            config.bookId,
            config.unitId]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return 0
        }
        var count = 0
        if result.next() {
            count = Int(result.int(forColumn: "count"))
        }
        return count
    }

    func getExerciseList(learn config: YXLearnConfig, includeNewWord: Bool, includeReviewWord: Bool) -> [YXExerciseModel] {
        var modelList = [YXExerciseModel]()
        var sql = YYSQLManager.ExerciseSQL.getAllExercise.rawValue
        if includeNewWord && !includeReviewWord {
            // 仅获取新学
            sql += " and is_new = 1"
        } else if !includeNewWord && includeReviewWord {
            // 仅获取复习
            sql += " and is_new = 0"
        } else if !includeNewWord && !includeReviewWord {
            // 都不获取
            return []
        }
        let params: [Any] = [
            config.learnType.rawValue,
            config.planId,
            config.bookId,
            config.unitId]
        let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params)
        while result?.next() == .some(true) {
            if let model = self.transformModel(result: result) {
                modelList.append(model)
            }
        }
        return modelList
    }

    func deleteExercise(study id: Int) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.deleteExerciseWithStudy.rawValue
        let params: [Any] = [id]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
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
//        model.wrongCount   = Int(result.int(forColumn: "wrong_count"))
        model.isNewWord    = result.bool(forColumn: "is_new")
        model.unfinishStepCount = Int(result.int(forColumn: "unfinish_count"))
        return model
    }
}
