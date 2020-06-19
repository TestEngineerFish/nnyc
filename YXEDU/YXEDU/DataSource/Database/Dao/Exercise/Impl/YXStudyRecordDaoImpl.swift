//
//  YXStudyRecordDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStudyRecordDaoImpl: YYDatabase, YXStudyRecordDao {

    func insertStudyRecord(learn config: YXLearnConfig) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.insertStudyRecord.rawValue
        var params: [Any] = config.params
        params.append(YXExerciseProgress.learning.rawValue)
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        return result ? Int(wordRunner.lastInsertRowId) : 0
    }
    
    func selectStudyRecordModel(learn config: YXLearnConfig) -> YXStudyRecordModel? {
        let sql = YYSQLManager.StudyRecordSQL.selectStudy.rawValue
        let params = [config.params]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return nil
        }
        var model: YXStudyRecordModel?
        if result.next() {
            model = YXStudyRecordModel()
            model?.learnConfg       = config
            model?.studyId          = Int(result.int(forColumn: "study_id"))
            model?.studyCount       = Int(result.int(forColumn: "study_count"))
            model?.startTime        = result.string(forColumn: "start_time") ?? ""
            model?.studyDuration    = Int(result.int(forColumn: "study_duration"))
            let progress            = Int(result.int(forColumn: "status"))
            model?.progress         = YXExerciseProgress(rawValue: progress) ?? .none
        }
        result.close()
        return model
    }

    func selectStudyCount(learn config: YXLearnConfig) -> Int {
        var count = 0
        let sql = YYSQLManager.StudyRecordSQL.selectStudy.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: config.params) else {
            return count
        }
        if result.next() {
            count = Int(result.int(forColumn: "study_count"))
        }
        result.close()
        return count
    }

    func updateProgress(studyId: Int, progress: YXExerciseProgress) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.updateProgress.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [progress.rawValue, studyId])
    }
    
    func addStudyCount(study id: Int) {
        let sql = YYSQLManager.StudyRecordSQL.addStudyCount.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }

    func setStartTime(study id: Int) {
        let sql = YYSQLManager.StudyRecordSQL.setStartTime.rawValue
        self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }

    func getBaseStudyLastStartTime() -> Date? {
        var time: Date?
        let sql = YYSQLManager.StudyRecordSQL.selectLastStartTime.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: []) else {
            return time
        }
        if result.next() {
            let dateStr = result.string(forColumn: "create_ts")
            time = NSDate(string: dateStr, format: NSDate.ymdHmsFormat()) as Date?
        }
        result.close()
        return time?.local()
    }

    func setDurationTime(study id: Int, duration time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateDurationTime.rawValue
        let params: [Any] = [time, id]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getStartTime(learn config: YXLearnConfig) -> String {
        return self.selectStudyRecordModel(learn: config)?.startTime ?? ""
    }

    func getDurationTime(learn config: YXLearnConfig) -> Int {
        return self.selectStudyRecordModel(learn: config)?.studyDuration ?? 0
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

    func deleteAllStudyRecord() -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.deleteAllRecord.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [])
    }
}
