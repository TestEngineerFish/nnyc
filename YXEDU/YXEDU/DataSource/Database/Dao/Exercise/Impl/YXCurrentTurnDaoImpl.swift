//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import FMDB

class YXCurrentTurnDaoImpl: YYDatabase, YXCurrentTurnDao {
    func insertCurrentTurn(studyId: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.insertTurn.rawValue
        let params = [studyId, studyId]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }
    
    func selectExercise() -> YXExerciseModel? {
        let sql = YYSQLManager.CurrentTurnSQL.selectExercise.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self.createExercise(rs: result)
        }
        result.close()
        return exercise
    }
    
    func selectExercise(type: YXQuestionType, step: Int, size: Int) -> [YXExerciseModel] {
        let sql = YYSQLManager.CurrentTurnSQL.selectConnectionExercise.rawValue
        let params: [Any] = [type.rawValue, step, size]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return []
        }
        var es: [YXExerciseModel] = []
        while result.next() {
            es.append(self.createExercise(rs: result))
        }
        result.close()
        
        return es
    }
    
    func selectBackupExercise(exerciseId: Int, step: Int) -> YXExerciseModel? {
        let sql = YYSQLManager.WordStepSQL.selectBackupStep.rawValue
        let params = [exerciseId, step]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var exercise: YXExerciseModel?
        if result.next() {
            exercise = self.createExercise(rs: result)
        }
        result.close()
        return exercise
    }
    
    // 暂时没有使用
    func selectConnectionType() -> (YXQuestionType, Int)? {
        let sql = YYSQLManager.CurrentTurnSQL.selectConnectionType.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return nil
        }
        if result.next() {
            let type = YXQuestionType(rawValue: result.string(forColumn: "question_type") ?? "") ?? YXQuestionType.none
            let step = Int(result.int(forColumn: "step"))
            result.close()
            
            return (type, step)
        }
        result.close()
        return nil
    }
    
    func selectTurnFinishStatus(studyId: Int) -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.selectTurnFinishStatus.rawValue        
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [studyId]) else {
            return true
        }
        if result.next() {
            let finish = result.bool(forColumn: "finish")
            result.close()
            return finish
        }
        result.close()
        return true
    }
    
    func updateExerciseFinishStatus(stepId: Int) -> Bool {
        return false
    }
    
    func deleteCurrentTurn() -> Bool {
        let sql = YYSQLManager.CurrentTurnSQL.deleteTurn.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
    
    func createExercise(rs: FMResultSet) ->YXExerciseModel {
        var model = YXExerciseModel()
        model.eid           = Int(rs.int(forColumn: "exercise_id"))
        model.stepId        = Int(rs.int(forColumn: "step_id"))
        model.wordId        = Int(rs.int(forColumn: "word_id"))
        model.type          = YXQuestionType(rawValue: rs.string(forColumn: "question_type") ?? "") ?? .none
        model.step          = Int(rs.int(forColumn: "step"))
        
        // 单词
        model.word          = YXWordModel()
        model.word?.wordId  = Int(rs.int(forColumn: "word_id"))
        model.word?.bookId  = Int(rs.int(forColumn: "book_id"))
        model.word?.unitId  = Int(rs.int(forColumn: "unit_id"))

        // 问题
        var question        = YXExerciseQuestionModel()
        question.wordId     = Int(rs.int(forColumn: "word_id"))
        question.word       = rs.string(forColumn: "question_word_content")
        question.itemCount  = Int(rs.int(forColumn: "question_option_count"))
        question.column     = Int(rs.int(forColumn: "question_column_count"))
        question.row        = Int(rs.int(forColumn: "question_row_count"))
        
        var extend          = YXExerciseQuestionExtendModel()
        extend.power        = Int(rs.int(forColumn: "question_ext_power"))

        
        question.extend     = extend
        model.question      = question
        
        return model
    }
    
}
