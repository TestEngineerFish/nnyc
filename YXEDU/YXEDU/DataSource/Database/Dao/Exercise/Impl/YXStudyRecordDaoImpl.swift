//
//  YXStudyRecordDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStudyRecordDaoImpl: YYDatabase, YXStudyRecordDao {
    
    func selectStudyRecordModel(config: YXLearnConfig) -> YXStudyRecordModel? {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params = configParams(config: config)
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var model: YXStudyRecordModel?
        if result.next() {
            model = YXStudyRecordModel()
            model?.learnConfg       = config
            model?.studyId          = Int(result.int(forColumn: "study_id"))
            model?.ruleType         = YXExerciseRuleType(rawValue: result.string(forColumn: "rule_type") ?? "") ?? .p0
            model?.currentGroup     = Int(result.int(forColumn: "current_group"))
            model?.currentTurn      = Int(result.int(forColumn: "current_turn"))
            
        }
        result.close()
        return model
    }
    
    func getStudyID(learn config: YXLearnConfig) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params = configParams(config: config)
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return .zero
        }
        if result.next() {
            return Int(result.int(forColumn: "study_id"))
        }
        return 0
    }

    func isFinished(learn config: YXLearnConfig) -> Bool? {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params: [Any] = [
            config.learnType.rawValue,
            config.planId as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        if result.next() {
            return result.bool(forColumn: "complete")
        }
        return nil
    }

    func insertStudyRecord(learn config: YXLearnConfig, type: YXExerciseRuleType, turn: Int) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.insertStudyRecord.rawValue
        let params: [Any] = [
            type.rawValue,
            config.learnType.rawValue,
            config.bookId,
            config.unitId,
            config.planId,
            turn
        ]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params) ? Int(wordRunner.lastInsertRowId) : 0
    }
    
    
    func updateCurrentTurn(learn config: YXLearnConfig, turn: Int? = nil) -> Bool {
        var sql = YYSQLManager.StudyRecordSQL.updateCurrentTurn.rawValue
        var params: [Any] = [
            config.learnType.rawValue,
            config.bookId,
            config.unitId,
            config.planId,
        ]
        if let index = turn {
            sql = YYSQLManager.StudyRecordSQL.updateCurrentTurnByTurn.rawValue
            params.insert(index, at: 0)
        }
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }
    
    
    

    func setStartTime(learn config: YXLearnConfig, start time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateStartTime.rawValue
        let params: [Any] = [config.learnType.rawValue, config.planId as Any]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func setDurationTime(learn config: YXLearnConfig, duration time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateDurationTime.rawValue
        let params: [Any] = [config.learnType.rawValue, config.planId as Any]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getStartTime(learn config: YXLearnConfig) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
         let params: [Any] = [
            config.learnType.rawValue,
            config.planId as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return .zero
        }
        return Int(result.int(forColumn: "start_time"))
    }

    func getDurationTime(learn config: YXLearnConfig) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params: [Any] = [config.learnType.rawValue, config.planId as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return .zero
        }
        return Int(result.int(forColumn: "study_duration"))
    }

    func delete(study id: Int) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.deleteRecord.rawValue
        let params: [Any] = [id]
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    
    func configParams(config: YXLearnConfig) -> [Any] {
        return [
            config.learnType.rawValue,
            config.bookId,
            config.unitId,
            config.planId
        ]
        
    }
}
