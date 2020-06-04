//
//  YXStudyRecordDaoImpl.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXStudyRecordDaoImpl: YYDatabase, YXStudyRecordDao {

    func setStartTime(type: YXLearnType, plan id: Int?, start time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateStartTime.rawValue
        let params: [Any] = [type.rawValue, id as Any]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func setDurationTime(type: YXLearnType, plan id: Int?, duration time: Int) {
        let sql = YYSQLManager.StudyRecordSQL.updateDurationTime.rawValue
        let params: [Any] = [type.rawValue, id as Any]
        self.wordRunner.executeUpdate(sql, withArgumentsIn: params)
    }

    func getStartTime(type: YXLearnType, plan id: Int?) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
         let params: [Any] = [type.rawValue, id as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return .zero
        }
        return Int(result.int(forColumn: "start_time"))
    }

    func getDurationTime(type: YXLearnType, plan id: Int?) -> Int {
        let sql = YYSQLManager.StudyRecordSQL.getInfo.rawValue
        let params: [Any] = [type.rawValue, id as Any]
        guard let result = self.wordRunner.executeQuery(sql, withArgumentsIn: params) else {
            return .zero
        }
        return Int(result.int(forColumn: "study_duration"))
    }
}
