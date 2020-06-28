//
//  YYDatabaseConfig.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

//MARK: 建表语句 =========================
struct YYSQLManager {
    
    // 创建词书数据表
    static let CreateWordTables: [String] = {
        var sqlArray = [CreateWordTableSQLs.bookTable.rawValue,
                        CreateWordTableSQLs.wordTable.rawValue,
                        CreateWordTableSQLs.searchHistoryTable.rawValue,
                        CreateWordTableSQLs.stepConfigTable.rawValue
        ]
        return sqlArray + CreateExerciseTables
    }()

    // 创建学习训练数据表
    static let CreateExerciseTables: [String] = [
        CreateExerciseTableSQLs.studyRecord.rawValue,
        CreateExerciseTableSQLs.allExercise.rawValue,
        CreateExerciseTableSQLs.allWordStep.rawValue,
        CreateExerciseTableSQLs.currentTurn.rawValue,
    ]
}

extension YYSQLManager {
    
    enum  CreateWordTableSQLs: String {
        case bookTable =
        """
        CREATE TABLE IF NOT EXISTS book (
        bookId integer PRIMARY KEY NOT NULL,
        bookName text,
        bookSource text,
        bookHash char(64),
        gradeId integer,
        gradeType integer
        )
        """
        
        case wordTable =
        """
        CREATE TABLE IF NOT EXISTS word (
        id integer primary key,
        wordId integer NOT NULL,
        word char(64),
        partOfSpeechAndMeanings text,
        imageUrl varchar(512),
        englishPhoneticSymbol char(128),
        americanPhoneticSymbol char(128),
        englishPronunciation varchar(128),
        americanPronunciation varchar(128),
        deformations text,
        examples text,
        fixedMatchs text,
        commonPhrases text,
        wordAnalysis text,
        detailedSyntaxs text,
        synonyms text,
        antonyms text,
        gradeId integer,
        gardeType integer,
        bookId integer,
        unitId integer,
        unitName varchar(512),
        isExtensionUnit integer
        )
        """
        
        case searchHistoryTable =
        """
        CREATE TABLE IF NOT EXISTS search_history_table (
        id integer primary key,
        wordId integer NOT NULL,
        word char(64),
        partOfSpeechAndMeanings text,
        englishPhoneticSymbol char(128),
        americanPhoneticSymbol char(128),
        englishPronunciation varchar(128),
        americanPronunciation varchar(128),
        isComplexWord integer
        );
        """

        case stepConfigTable =
        """
        CREATE TABLE IF NOT EXISTS step_config_table_v1 (
        id integer primary key,
        wordId integer NOT NULL,
        step integer,
        black_list text
        )
        """
    }

    /// 练习相关的数据表
    enum  CreateExerciseTableSQLs: String {

        // 学习记录表
        case studyRecord =
        """
        CREATE TABLE IF NOT EXISTS study_record_v1 (
        study_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
        learn_type integer(1),
        book_id integer(4) NOT NULL DEFAULT(0),
        unit_id integer(4) NOT NULL DEFAULT(0),
        plan_id integer(4) NOT NULL DEFAULT(0),
        homework_id integer(4) NOT NULL DEFAULT(0),
        status integer(1) NOT NULL DEFAULT(0),
        study_count integer(1) NOT NULL DEFAULT(0),
        study_duration integer(4) NOT NULL DEFAULT(0),
        start_time integer(32) NOT NULL DEFAULT(datetime('now', 'localtime')),
        create_ts text(32) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """

        // 所有的训练
        case allExercise =
        """
        CREATE TABLE IF NOT EXISTS all_exercise_v1 (
        exercise_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
        study_id integer(8) NOT NULL,
        learn_type integer(1) NOT NULL,
        word_id integer NOT NULL,
        word char(128),
        book_id integer(4) NOT NULL DEFAULT(0),
        unit_id integer(8) NOT NULL DEFAULT(0),
        word_type integer(1) NOT NULL DEFAULT(0),
        score integer(1) NOT NULL DEFAULT(10),
        next_step text(32) NOT NULL DEFAULT('END'),
        create_ts text(32) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """

        // 所有单词的步骤
        case allWordStep =
        """
        CREATE TABLE IF NOT EXISTS all_word_step_v1 (
        step_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
        study_id integer(8) NOT NULL,
        exercise_id integer(8) NOT NULL,
        word_id integer DEFAULT(0),
        book_id integer NOT NULL DEFAULT(0),
        unit_id integer NOT NULL DEFAULT(0),
        question_type char(10),
        question_option text,
        question text,
        operate text,
        step text,
        rule text,
        status integer(1) DEFAULT(0),
        wrong_count integer(2) DEFAULT(0),
        create_ts text(128) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """

        // 当前轮次表
        case currentTurn =
        """
        CREATE TABLE IF NOT EXISTS current_turn_v1 (
        current_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
        study_id integer NOT NULL,
        step_id integer NOT NULL,
        finish integer(1) NOT NULL DEFAULT(0),
        create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
    }

}
