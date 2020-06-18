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
        all_exercise_v1(
            study_id,
            learn_type,
            word_id,
            word,
            book_id,
            unit_id,
            word_type,
            next_step
        )
        values(?, ?, ?, ?, ?, ?, ?, ?)
        """

        case getNewWordList =
        """
        SELECT w.* FROM all_exercise_v1 as e JOIN word as w
        WHERE e.word_id = w.wordId and e.unit_id = w.unitId and e.book_id = w.bookId and e.word_type = 1
        """

        case getReviewWordList =
        """
        SELECT w.* FROM all_exercise_v1 as e JOIN word as w
        WHERE e.word_id = w.wordId and e.unit_id = w.unitId and e.book_id = w.bookId and e.word_type = 0
        """



        case updateScore =
        """
        UPDATE all_exercise_v1
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
        SELECT * FROM all_exercise_v1
        WHERE exercise_id = ?
        """

        case updateUnfinishedCount =
        """
        UPDATE all_exercise_v1
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
        UPDATE all_exercise_v1
        SET mastered = ?
        WHERE exercise_id = ?
        """

        case getExerciseCount =
        """
        SELECT count(*) FROM all_exercise_v1
        WHERE study_id = ?
        """

        case getAllExercise =
        """
        SELECT * FROM all_exercise_v1
        WHERE study_id = ?
        """

        case getUnfinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise_v1
        WHERE unfinish_count != 0 and is_new = ? and study_id = ?
        """

        case getFinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise_v1
        WHERE unfinish_count = 0 and is_new = ? and study_id = ?
        """

        case deleteExerciseWithStudy =
        """
        DELETE FROM all_exercise_v1
        WHERE study_id = ?
        """

        case deleteExpiredExercise = "delete from all_exercise_v1 where date(create_ts) < date('now', 'localtime')"

        case deleteAllExercise = "delete from all_exercise_v1"
    }
}
