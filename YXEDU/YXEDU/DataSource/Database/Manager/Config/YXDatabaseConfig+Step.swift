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
        insert into
        all_word_step_v1(
            study_id,
            exercise_id,
            word_id,
            book_id,
            unit_id,
            question_type,
            question,
            operate,
            step,
            rule
        )
        values(?, ?, ?, ?, ?,
               ?, ?, ?, ?, ?)
        """

        case updateWordStep =
        """
        UPDATE all_word_step_v1
        SET status =
        (SELECT CASE
            WHEN status = 0
            THEN 0
            ELSE ?
            END
        ),
        wrong_count = wrong_count + ?
        WHERE step_id = ?
        """

//        case selectUnfinishMinGroup =
//        """
//        select min(group_index) current_group from all_word_step_v1
//        where (status = 0 or status = 1) and study_id = ?
//        """


        case selectWordStep =
        """
        select mastered, s.* from all_exercise_v1 e inner join all_word_step_v1 s
        on e.exercise_id = s.exercise_id
        where s.study_id = ? and s.word_id = ? and s.step = ?
        """
        
        case selsetSteps =
        """
        SELECT * FROM all_word_step_v1
        WHERE exercise_id = ? and step != 0
        """

//        case selectStepCount =
//        """
//        SELECT count(*) count FROM all_word_step_v1
//        WHERE exercise_id = ? and step = ?
//        """

        case selectMinStepWrongCount =
        """
        select min(step) min_step, wrong_count from all_word_step_v1 where study_id = ? and word_id = ? and step != 0
        """

//        case updatePreviousWrongStatus =
//        """
//        update all_word_step_v1 set status = 0 where step_id in (select step_id from current_turn where study_id = ?)
//        and status = 1
//        """

        case selectBackupStep =
        """
        select * from all_word_step_v1
        where study_id = ? and exercise_id = ? and step = ? and backup = 1
        """

        case selectUnfinishMinStep =
        """
        select min(step) step from all_word_step_v1
        where study_id = ? and group_index = ? and backup = 0
        and (status = 0 or status = 1)
        """

        case deleteStep =
        """
        DELETE FROM all_word_step_v1
        WHERE exercise_id = ? and step = ? and score = ?
        """

        case deleteStepWithStudy =
        """
        DELETE FROM all_word_step_v1
        WHERE study_id = ?
        """

        case deleteExpiredWordStep = "delete from all_word_step_v1 where date(create_ts) < date('now', 'localtime')"

        case deleteAllWordStep = "delete from all_word_step_v1"

        case selectInfo =
         """
         SELECT * FROM all_word_step_v1
         WHERE exercise_id = ? and step = ?
         """
        case selectExerciseStep =
        """
        SELECT * FROM all_word_step_v1
        WHERE exercise_id = ?
        """
    }
}
