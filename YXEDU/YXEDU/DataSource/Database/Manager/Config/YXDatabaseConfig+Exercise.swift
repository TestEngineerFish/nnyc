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

        case getNewWordExerciseAmount =
        """
        SELECT count(*) amount FROM all_exercise_v1
        WHERE study_id = ? and word_type = 1
        """

        case getReviewWordExerciseAmount =
        """
        SELECT count(*) amount FROM all_exercise_v1
        WHERE study_id = ? and word_type = 0
        """

        case getAllWordExerciseAmount =
        """
        SELECT count(*) amount FROM all_exercise_v1
        WHERE study_id = ?
        """

        case updateNextStep =
        """
        UPDATE all_exercise_v1
        SET next_step = ?
        WHERE exercise_id = ?
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

        case getAllExercise =
        """
        SELECT * FROM all_exercise_v1
        WHERE study_id = ?
        """

        case getUnfinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise_v1
        WHERE next_step != 'end' and word_type = ? and study_id = ?
        """

        case getFinishedWordsAmount =
        """
        SELECT count(*) count FROM all_exercise_v1
        WHERE next_step = 'end' and word_type = ? and study_id = ?
        """

        case deleteExerciseWithStudy =
        """
        DELETE FROM all_exercise_v1
        WHERE study_id = ?
        """

        case deleteExpiredExercise =
        """
        DELETE FROM all_exercise_v1
        WHERE date(create_ts) < date('now', 'localtime')
        """

        case deleteAllExercise =
        """
        DELETE FROM all_exercise_v1
        """
    }
}
