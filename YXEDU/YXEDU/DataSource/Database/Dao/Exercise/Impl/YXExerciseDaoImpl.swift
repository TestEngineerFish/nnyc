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
    
    func insertExercise(learn config: YXLearnConfig, rule: YXExerciseRule, study recordId: Int, exerciseModel: YXExerciseModel) -> Int {
        
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

    func updateScore(exercise id: Int, reduceScore: Int) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateScore.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [reduceScore, reduceScore, id])
    }

    func updateUnfinishedCount(exercise id: Int, reduceCount: Int) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateUnfinishedCount.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [reduceCount, id])
    }

    func updateMastered(exercise id: Int, isMastered: Bool) -> Bool {
        let sql = YYSQLManager.ExerciseSQL.updateMastered.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [isMastered ? 1 : 0, id])
    }

    
    func getExerciseCount(studyId: Int, includeNewWord: Bool, includeReviewWord: Bool) -> Int {
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
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return 0
        }
        var count = 0
        if result.next() {
            count = Int(result.int(forColumn: "count"))
        }
        result.close()
        return count
    }

    func getExerciseList(studyId: Int, includeNewWord: Bool, includeReviewWord: Bool) -> [YXExerciseModel] {
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
        let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId])
        while result?.next() == .some(true) {
            if let model = self.transformModel(result: result) {
                modelList.append(model)
            }
        }
        result?.close()
        return modelList
    }

    func getNewWordCount(studyId: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.ExerciseSQL.getWordsCount.rawValue
        let params: [Any] = [1, studyId]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            count = Int(result.int(forColumn: "count"))
            result.close()
        }
        return count
    }

    func getReviewWordCount(studyId: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.ExerciseSQL.getWordsCount.rawValue
        let params: [Any] = [0, studyId]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            count = Int(result.int(forColumn: "count"))
            result.close()
        }
        return count
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
        model.isNewWord    = result.bool(forColumn: "is_new")
        model.unfinishStepCount = Int(result.int(forColumn: "unfinish_count"))
        return model
    }
}
