//
//  YXDatabaseConfig+Step.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    enum WordStepSQL: String {

        case insertWordStep =
        """
        INSERT INTO
        all_word_step_v1(
        study_id,
        exercise_id,
        word_id,
        book_id,
        unit_id,
        question_type,
        question_option,
        question,
        operate,
        step,
        rule
        )
        VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """

        case updateWordStep =
        """
        UPDATE all_word_step_v1
        SET status =
        (SELECT CASE
        WHEN status = 1
        THEN 1
        ELSE ?
        END
        ),
        wrong_count = wrong_count + ?
        WHERE step_id = ?
        """
        
        case selectStepsWithExercise =
        """
        SELECT * FROM all_word_step_v1
        WHERE exercise_id = ?
        """

        case deleteStepWithStudy =
        """
        DELETE FROM all_word_step_v1
        WHERE study_id = ?
        """

        case deleteExpiredWordStep =
        """
        DELETE FROM all_word_step_v1
        WHERE date(create_ts) < date('now', 'localtime')
        """

        case deleteAllWordStep =
        """
        DELETE FROM all_word_step_v1
        """
    }
}
