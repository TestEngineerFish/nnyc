//
//  YXDatabaseConfig+Exercise.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YYSQLManager {
    // 创建学习训练数据表
    static let CreateExerciseTables: [String] = [
        CreateExerciseTableSQLs.studyRecord.rawValue,
        CreateExerciseTableSQLs.allExercise.rawValue,
        CreateExerciseTableSQLs.allWordStep.rawValue,
        CreateExerciseTableSQLs.currentTurn.rawValue,
    ]
    
    /// 练习相关的数据表
    enum  CreateExerciseTableSQLs: String {
        
        // 学习记录表
        case studyRecord =
        """
        CREATE TABLE IF NOT EXISTS study_record (
            id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            rule_type char(10),
            learn_type integer(1),
            book_id integer(4),
            unit_id integer(4),
            plan_id integer(4),
            current_group integer(1),
            current_turn integer(2),
            study_duration integer(4),
            start_time integer(8),
            create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
        
        // 所有的训练
        case allExercise =
        """
        CREATE TABLE IF NOT EXISTS all_exercise (
            exercise_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            rule_type char(10),
            learn_type integer(1) NOT NULL,
            word_id integer NOT NULL,
            word char(128),
            book_id integer(4),
            unit_id integer(8),
            plan_id integer(8),
            is_new integer(1) NOT NULL DEFAULT(0),
            mastered integer(1) NOT NULL DEFAULT(0),
            score integer(1) NOT NULL DEFAULT(10),
            unfinish_count integer(1) NOT NULL DEFAULT(0),
            create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
        
        // 所有单词的步骤
        case allWordStep =
        """
        CREATE TABLE IF NOT EXISTS all_word_step (
            step_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            exercise_id integer(8) NOT NULL,
            word_id integer DEFAULT(0),
            book_id integer,
            unit_id integer,
            question_type char(10),
            question_word_content varchar,
            question_option_count integer(1),
            question_row_count integer(1),
            question_column_count integer(1),
            question_ext_power integer(1),
            answer text,
            score integer(1),
            care_score integer(1) DEFAULT(0),
            step integer(1),
            backup integer(1),
            status integer(1) DEFAULT(-1),
            wrong_score integer(1),
            wrong_rate integer(1),
            wrong_count integer(2) DEFAULT(0),
            group_index integer(1) NOT NULL DEFAULT(0),
            invalid integer(1) DEFAULT(0),
            create_ts text(128) NOT NULL DEFAULT(datetime('now'))
        );
        """
        
        // 当前轮次表
        case currentTurn =
        """
        CREATE TABLE IF NOT EXISTS current_turn (
            step_id integer PRIMARY KEY NOT NULL,
            finish integer(1) NOT NULL DEFAULT(0),
            turn_index integer(1) NOT NULL DEFAULT(1)
        );
        """
    }
    
    
    // MARK: Update & Select
    enum StudyRecordSQL: String {
        
        case insertStudyRecord =
        """
        insert into
        study_record(
            rule_type,
            learn_type,
            book_id,
            unit_id,
            plan_id
        )
        values(?, ?, ?, ?, ?)
        """
        
        case insertCurrentExercise =
        """

        """

        case getInfo =
        """
        SELECT * FROM study_record
        WHERE learn_type = ? and plan_id = ?
        """

        case updateStartTime =
        """
        UPDATE study_record
        SET start_time = ?
        WHERE learn_type = ? and plan_id = ?
        """

        case updateDurationTime =
        """
        UPDATE study_record
        SET study_duration = ?
        WHERE learn_type = ? and plan_id = ?
        """
        
        
        case deleteExpiredExercise = "delete from all_exercise where date(create_ts) < date('now')"
        
        case deleteAllExercise = "delete from all_exercise"
    }
    
    enum ExerciseSQL: String {
        
        case insertExercise =
        """
        insert into
        all_exercise(
            rule_type,
            learn_type,
            word_id,
            word,
            book_id,
            unit_id,
            plan_id,
            is_new,
            unfinish_count
        )
        values(?, ?, ?, ?, ? , ?, ?, ?, ?)
        """
        
        case insertCurrentExercise =
        """

        """

        case updateExercise =
        """
        UPDATE all_exercise
        SET mastered = ?, score = ?, unfinish_count = ?
        WHERE exercise_id = ?
        """

        case getAllExercise =
        """
        SELECT * FROM all_exercise
        WHERE learn_type = ? and plan_id = ?
        """
        
        case deleteExpiredExercise = "delete from all_exercise where date(create_ts) < date('now')"
        
        case deleteAllExercise = "delete from all_exercise"
    }
    
    
    enum WordStepSQL: String {
        
        case insertWordStep =
        """
        insert into
        all_word_step(
            exercise_id,
            word_id,
            book_id,
            unit_id,
            question_type,
            question_word_content,
            question_option_count,
            question_row_count,
            question_column_count,
            question_ext_power,
            score,
            care_score,
            step,
            backup,
            wrong_score,
            wrong_rate,
            group_index
        )
        values(
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?
        )
        """

        case updateWordStep =
        """
        UPDATE all_word_step
        SET score = ?, status = ?, wrong_count = ?
        WHERE exercise_id = ? and step = ? and score = ?
        """

        case selsetStps =
        """
        SELECT * FROM all_word_step
        WHERE exercise_id = ? and step != 0
        """

        case deleteStep =
        """
        DELETE FROM all_word_step
        WHERE exercise_id = ? and step = ? and score = ?
        """
        
        case deleteExpiredWordStep = "delete from all_word_step where date(create_ts) < date('now')"
        
        case deleteAllWordStep = "delete from all_word_step"
    }
}
