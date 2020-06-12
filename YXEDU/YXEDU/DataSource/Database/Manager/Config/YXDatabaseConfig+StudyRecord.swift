//
//  YXDatabaseConfig+StudyRecord.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {

    enum StudyRecordSQL: String {

        case insertStudyRecord =
        """
        INSERT INTO
        study_record(
            rule_type,
            learn_type,
            book_id,
            unit_id,
            plan_id,
            current_turn,
            status
        )
        values(?, ?, ?, ?, ?, ?, ?)
        """

        case selectStudyRecord_Base =
        """
        SELECT * FROM study_record
        where learn_type = ? and book_id = ? and unit_id = ?
        """

        case selectStudyRecord_Review =
        """
        SELECT * FROM study_record
        where learn_type = ? and plan_id = ?
        """


        // 更新学习的当前组下标
        case updateCurrentGroup =
        """
        update study_record set current_group = ? where study_id = ?
        """

        /// 更新学习进度
        case updateProgress =
        """
        update study_record set status = ? where study_id = ?
        """

        // 更新学习的当前轮下标，轮参数自增
        case updateCurrentTurn =
        """
        update study_record set current_turn = current_turn + 1
        where study_id = ?
        """

        // 更新学习的当前轮下标，指定轮参数
        case updateCurrentTurnByTurn =
        """
        update study_record set current_turn = ?
        where study_id = ?
        """

        case updateStartTime =
        """
        UPDATE study_record
        SET start_time = datetime('now', 'localtime')
        WHERE study_id = ?
        """

        case selectLastStartTime =
        """
        SELECT * FROM study_record
        WHERE learn_type = 1
        ORDER BY create_ts desc
        LIMIT 1
        """

        case updateStudyCount =
        """
        UPDATE study_record
        SET study_count = study_count + 1
        WHERE study_id = ?
        """

        case updateDurationTime =
        """
        UPDATE study_record
        SET study_duration = study_duration + ?
        WHERE study_id = ?
        """

        case deleteRecord =
        """
        DELETE FROM study_record
        WHERE study_id = ?
        """

        case deleteExpiredRecord =
        """
        DELETE FROM study_record
        WHERE date(create_ts) < date('now', 'localtime')
        """

        case deleteAllRecord =
        """
        DELETE FROM study_record
        """
    }
    
}
