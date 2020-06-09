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
            model?.studyCount       = Int(result.int(forColumn: "study_count"))
            
        }
        result.close()
        return model
    }
    
    func getStudyID(learn config: YXLearnConfig) -> Int {
        var studyId = 0
        let sql     = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params  = configParams(config: config)
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            studyId = Int(result.int(forColumn: "study_id"))
            result.close()
        }
        return studyId
    }

    func getProgress(learn config: YXLearnConfig) -> YXExerciseProgress {
        var progress = YXExerciseProgress.none
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: config.params), result.next() {
            let progressInt = Int(result.int(forColumn: "status"))
            result.close()
            progress = YXExerciseProgress(rawValue: progressInt) ?? .none
            result.close()
        }
        return progress
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

    func addStudyCount(learn config: YXLearnConfig) {
        let sql = YYSQLManager.StudyRecordSQL.updateStudyCount.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: config.params)
    }

    func setStartTime(learn config: YXLearnConfig) {
        let sql = YYSQLManager.StudyRecordSQL.updateStartTime.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: config.params)
    }

    func setDurationTime(learn config: YXLearnConfig, duration time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateDurationTime.rawValue
        let params: [Any] = [time, config.learnType.rawValue, config.bookId, config.unitId, config.planId]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getStartTime(learn config: YXLearnConfig) -> String {
        var startTime = ""
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params: [Any] = [
            config.learnType.rawValue,
            config.bookId,
            config.unitId,
            config.planId]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            startTime = result.string(forColumn: "start_time") ?? ""
            result.close()
        }
        return startTime
    }

    func getDurationTime(learn config: YXLearnConfig) -> Int {
        var duration = 0
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params: [Any] = [config.learnType.rawValue, config.bookId, config.unitId, config.planId]
        if let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params), result.next() {
            duration = Int(result.int(forColumn: "study_duration"))
            result.close()
        }
        return duration
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

    func deleteAllStudyRecord() -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.deleteAllRecord.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
}
