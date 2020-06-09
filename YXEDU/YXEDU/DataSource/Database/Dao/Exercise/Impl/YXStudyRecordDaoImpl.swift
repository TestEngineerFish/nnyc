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
        
        var sql = YYSQLManager.StudyRecordSQL.selectStudyRecord_Review.rawValue
        var params = [config.learnType.rawValue, config.planId]
        if config.learnType == .base {
            sql = YYSQLManager.StudyRecordSQL.selectStudyRecord_Base.rawValue
            params = [config.learnType.rawValue, config.bookId, config.unitId]
        }

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
            
            model?.startTime = result.string(forColumn: "start_time") ?? ""
            model?.studyDuration = Int(result.int(forColumn: "study_duration"))
            
            let progressInt = Int(result.int(forColumn: "status"))
            model?.progress = YXExerciseProgress(rawValue: progressInt) ?? .none
        }
        result.close()
        return model
    }
    
    func getStudyID(learn config: YXLearnConfig) -> Int {
        return self.selectStudyRecordModel(config: config)?.studyId ?? 0
    }

    func getProgress(learn config: YXLearnConfig) -> YXExerciseProgress {
        return selectStudyRecordModel(config: config)?.progress ?? .none
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
    
    
    func updateCurrentTurn(studyId: Int, turn: Int? = nil) -> Bool {
        var sql = YYSQLManager.StudyRecordSQL.updateCurrentTurn.rawValue
        var params: [Any] = [studyId]
        
        if let index = turn {
            sql = YYSQLManager.StudyRecordSQL.updateCurrentTurnByTurn.rawValue
            params.insert(index, at: 0)
        }
        
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func addStudyCount(studyId: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateStudyCount.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
    }

    func setStartTime(studyId: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateStartTime.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: [studyId])
    }

    func setDurationTime(studyId: Int, duration time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateDurationTime.rawValue
        let params: [Any] = [time, studyId]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getStartTime(learn config: YXLearnConfig) -> String {
        return self.selectStudyRecordModel(config: config)?.startTime ?? ""
        
    }

    func getDurationTime(learn config: YXLearnConfig) -> Int {
        return self.selectStudyRecordModel(config: config)?.studyDuration ?? 0
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
