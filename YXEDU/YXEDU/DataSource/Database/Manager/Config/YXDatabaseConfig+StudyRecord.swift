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
        study_record_v1(
        learn_type,
        book_id,
        unit_id,
        plan_id,
        homework_id,
        status,
        new_word_count,
        unlearned_new_word_count,
        review_word_count,
        unlearned_review_word_count,
        unique_code
        )
        values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """

        case selectStudy =
        """
        SELECT * FROM study_record_v1
        WHERE learn_type = ? AND book_id = ? AND unit_id = ? AND plan_id = ? AND homework_id = ?
        """

        case selectStudyWithID =
        """
        SELECT * FROM study_record_v1
        WHERE study_id = ?
        """
        
        /// 更新学习进度
        case updateProgress =
        """
        UPDATE study_record_v1
        SET status = ?
        WHERE study_id = ?
        """

        case reduceUnlearnedNewWordCount =
        """
        UPDATE study_record_v1
        SET unlearned_new_word_count =
        (SELECT CASE
        WHEN unlearned_new_word_count <= 0
        THEN 0
        ELSE unlearned_new_word_count - 1
        END
        )
        WHERE study_id = ?
        """

        case reduceUnlearnedReviewWordCount =
        """
        UPDATE study_record_v1
        SET unlearned_review_word_count =
        (SELECT CASE
        WHEN unlearned_review_word_count <= 0
        THEN 0
        ELSE unlearned_review_word_count - 1
        END
        )
        WHERE study_id = ?
        """

        case reset =
        """
        update study_record_v1
        SET status = 0, study_count = 0, study_duration = 0
        WHERE study_id = ?
        """

        case setStartTime =
        """
        UPDATE study_record_v1
        SET start_time = datetime('now', 'localtime')
        WHERE study_id = ?
        """

        case selectLastStartTime =
        """
        SELECT * FROM study_record_v1
        WHERE learn_type = 1
        ORDER BY create_ts desc
        LIMIT 1
        """

        case addStudyCount =
        """
        UPDATE study_record_v1
        SET study_count = study_count + 1
        WHERE study_id = ?
        """

        case updateDurationTime =
        """
        UPDATE study_record_v1
        SET study_duration = study_duration + ?
        WHERE study_id = ?
        """

        case deleteRecord =
        """
        DELETE FROM study_record_v1
        WHERE study_id = ?
        """

        case deleteExpiredRecord =
        """
        DELETE FROM study_record_v1
        WHERE date(create_ts) < date('now', 'localtime')
        """

        case deleteAllRecord =
        """
        DELETE FROM study_record_v1
        """
    }
    
}
