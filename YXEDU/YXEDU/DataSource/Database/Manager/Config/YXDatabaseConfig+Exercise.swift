//
//  YXDatabaseConfig+Exercise.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    
    enum ExerciseSQL: String {

        case insertExercise =
        """
        insert into
        all_exercise(
            study_id,
            learn_type,
            word_id,
            word,
            book_id,
            unit_id,
            word_type,
            next_step,
        )
        values(?, ?, ?, ?, ?, ?, ?, ?)
        """

        case updateScore =
        """
        UPDATE all_exercise
        SET score =
        (score -
            (SELECT CASE
             WHEN score >= ?
             THEN ?
             ELSE score
             END
            )
        )
        WHERE exercise_id = ?
        """

        case selectExerciseInfo =
        """
        SELECT * FROM all_exercise
        WHERE exercise_id = ?
        """

        case updateUnfinishedCount =
        """
        UPDATE all_exercise
        SET unfinish_count =
        (unfinish_count -
            (SELECT CASE
             WHEN unfinish_count > 0
             THEN ?
             ELSE 0
             END
            )
        )
        WHERE exercise_id = ?
        """

        case updateMastered =
        """
        UPDATE all_exercise
        SET mastered = ?
        WHERE exercise_id = ?
        """

        case getExerciseCount =
        """
        SELECT count(*) FROM all_exercise
        WHERE study_id = ?
        """

        case getAllExercise =
        """
        SELECT * FROM all_exercise
        WHERE study_id = ?
        """

        case getUnfinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise
        WHERE unfinish_count != 0 and is_new = ? and study_id = ?
        """

        case getFinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise
        WHERE unfinish_count = 0 and is_new = ? and study_id = ?
        """

        case deleteExerciseWithStudy =
        """
        DELETE FROM all_exercise
        WHERE study_id = ?
        """

        case deleteExpiredExercise = "delete from all_exercise where date(create_ts) < date('now', 'localtime')"

        case deleteAllExercise = "delete from all_exercise"
    }
}
