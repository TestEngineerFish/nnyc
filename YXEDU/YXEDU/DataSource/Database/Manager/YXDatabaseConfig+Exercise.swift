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
        CreateExerciseTableSQLs.allExercise.rawValue,
        CreateExerciseTableSQLs.allWordStep.rawValue,
        CreateExerciseTableSQLs.currentExercise.rawValue
    ]
    
    /// 练习相关的数据表
    enum  CreateExerciseTableSQLs: String {
        // 所有的训练
        case allExercise =
        """
        CREATE TABLE IF NOT EXISTS all_exercise(
            e_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            rule_type char(10),
            learn_type integer(4) NOT NULL,
            word_id integer NOT NULL,
            word char(128),
            word_type integer(4) NOT NULL,
            book_id integer(8),
            unit_id integer(8),
            plan_id integer(8),
            status integer(2) NOT NULL DEFAULT(0),
            create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
        
        // 所有单词的步骤
        case allWordStep =
        """
        CREATE TABLE IF NOT EXISTS all_word_step (
            s_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            rule_type char(10),
            book_id integer,
            unit_id integer,
            learn_type integer NOT NULL DEFAULT(1),
            word_id integer NOT NULL DEFAULT(0),
            question_type char(10) NOT NULL DEFAULT('Q-A-1'),
            question_word_id integer DEFAULT(0),
            question_word_content varchar,
            question_option_count integer,
            question_row_count integer,
            question_column_count integer,
            question_ext_score integer,
            care_score integer(4),
            score integer,
            step integer(4),
            backup integer(4),
            finish integer(4),
            answer_right integer(4),
            repeat integer(4),
            answer integer,
            word_type integer,
            batch integer(4),
            batch_status integer(4),
            create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
        
        case currentExercise =
        """

        """
        
    }
    
    
    // MARK: Update & Select
    enum ExerciseSQL: String {
        
        case insertExercise =
        """
        insert into
        all_exercise(
            rule_type,
            learn_type,
            word_id,
            word,
            word_type,
            book_id,
            unit_id,
            plan_id
        )
        values(?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        case insertCurrentExercise =
        """

        """
        
        
        case deleteExpiredExercise = "delete from all_exercise where date(create_ts) < date('now')"
        
        case deleteAllExercise = "delete from all_exercise"
    }
    
    
    enum WordStepSQL: String {
        
        case insertWordStep =
        """
        insert into
        all_word_step(
            rule_type,
            book_id,
            unit_id,
            learn_type,
            word_id,
            question_type,
            question_word_id,
            question_word_content,
            question_option_count,
            question_row_count,
            question_column_count,
            question_ext_score,
            care_score,
            score,
            step,
            backup,
            answer,
            word_type
        )
        values(
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?, ?
        )
        """
        
        
        case deleteExpiredWordStep = "delete from all_word_step where date(create_ts) < date('now')"
        
        case deleteAllWordStep = "delete from all_word_step"
    }
}
