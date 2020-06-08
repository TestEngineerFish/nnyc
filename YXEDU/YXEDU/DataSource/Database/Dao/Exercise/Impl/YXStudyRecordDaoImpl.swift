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
            model?.ruleType         = YXExerciseRule(rawValue: result.string(forColumn: "rule_type") ?? "") ?? .p0
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

    func getProgress(learn config: YXLearnConfig) -> YXExerciseProgress {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: config.params) else {
            return .none
        }
        if result.next() {
            let progress = Int(result.int(forColumn: "status"))
            result.close()
            return YXExerciseProgress(rawValue: progress) ?? .none
        }
        result.close()
        return .none
    }

    func insertStudyRecord(learn config: YXLearnConfig, type: YXExerciseRule, turn: Int) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.insertStudyRecord.rawValue
        var params: [Any] = config.params
        params.insert(type.rawValue, at: 0)
        params.append(turn)
        params.append(YXExerciseProgress.learning.rawValue)
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params) ? Int(wordRunner.lastInsertRowId) : 0
    }

    func updateCurrentGroup(studyId: Int, group: Int) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.updateCurrentGroup.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [group, studyId])
    }
    
    func updateProgress(studyId: Int, progress: YXExerciseProgress) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.updateProgress.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [progress.rawValue, studyId])
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

    
    func deleteExpiredStudyRecord() -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.deleteExpiredRecord.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
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
