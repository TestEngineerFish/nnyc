//
//  YXStudyRecordDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStudyRecordDaoImpl: YYDatabase, YXStudyRecordDao {
    
    func insertStudyRecord(learn config: YXLearnConfig, newWordCount: Int, reviewWordCount: Int) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.insertStudyRecord.rawValue
        var params: [Any] = config.params
        params.append(YXExerciseProgress.learning.rawValue)
        params.append(newWordCount)
        params.append(newWordCount)
        params.append(reviewWordCount)
        params.append(reviewWordCount)
        let result = self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
        return result ? Int(wordRunner.lastInsertRowId) : 0
    }
    
    func selectStudyRecordModel(learn config: YXLearnConfig) -> YXStudyRecordModel? {
        let sql = YYSQLManager.StudyRecordSQL.selectStudy.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: config.params) else {
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

    func updateProgress(study id: Int, progress: YXExerciseProgress) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.updateProgress.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [progress.rawValue, id])
    }

    func reduceUnlearnedNewWordCount(study id: Int) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.reduceUnlearnedNewWordCount.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }

    func reduceUnlearnedReviewWordCount(study id: Int) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.reduceUnlearnedReviewWordCount.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
    }

    func reset(study id: Int) -> Bool {
        let sql = YYSQLManager.StudyRecordSQL.reset.rawValue
        return self.wordRunner.executeUpdate(sql, withArgumentsIn: [id])
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
    
    func getNewWordCount(study id: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.StudyRecordSQL.selectStudyWithID.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return count
        }
        if result.next() {
            count = Int(result.int(forColumn: "new_word_count"))
        }
        return count
    }

    func getUnlearnedNewWordCount(study id: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.StudyRecordSQL.selectStudyWithID.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return 0
        }
        if result.next() {
            count = Int(result.int(forColumn: "unlearned_new_word_count"))
        }
        return count
    }
    
    func getReviewWordCount(study id: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.StudyRecordSQL.selectStudyWithID.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return 0
        }
        if result.next() {
            count = Int(result.int(forColumn: "review_word_count"))
        }
        return count
    }

    func getUnlearnedReviewWordCount(study id: Int) -> Int {
        var count = 0
        let sql = YYSQLManager.StudyRecordSQL.selectStudyWithID.rawValue
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return 0
        }
        if result.next() {
            count = Int(result.int(forColumn: "unlearned_review_word_count"))
        }
        return count
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
