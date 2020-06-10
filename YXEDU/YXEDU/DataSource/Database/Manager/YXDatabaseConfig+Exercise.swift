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
            study_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            rule_type char(10),
            learn_type integer(1),
            book_id integer(4) NOT NULL DEFAULT(0),
            unit_id integer(4) NOT NULL DEFAULT(0),
            plan_id integer(4) NOT NULL DEFAULT(0),
            status integer(1) NOT NULL DEFAULT(0),
            current_group integer(1) NOT NULL DEFAULT(0),
            current_turn integer(2) NOT NULL DEFAULT(-1),
            study_count integer(1) NOT NULL DEFAULT(1),
            study_duration integer(4) NOT NULL DEFAULT(0),
            start_time integer(32) NOT NULL DEFAULT(datetime('now', 'localtime')),
            create_ts text(32) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """
        
        // 所有的训练
        case allExercise =
        """
        CREATE TABLE IF NOT EXISTS all_exercise (
            exercise_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            study_id integer(8) NOT NULL,
            rule_type char(10),
            learn_type integer(1) NOT NULL,
            word_id integer NOT NULL,
            word char(128),
            book_id integer(4) NOT NULL DEFAULT(0),
            unit_id integer(8) NOT NULL DEFAULT(0),
            plan_id integer(8) NOT NULL DEFAULT(0),
            is_new integer(1) NOT NULL DEFAULT(0),
            mastered integer(1) NOT NULL DEFAULT(0),
            score integer(1) NOT NULL DEFAULT(10),
            unfinish_count integer(1) NOT NULL DEFAULT(0),
            create_ts text(32) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """
        
        // 所有单词的步骤
        case allWordStep =
        """
        CREATE TABLE IF NOT EXISTS all_word_step (
            step_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            study_id integer(8) NOT NULL,
            exercise_id integer(8) NOT NULL,
            word_id integer DEFAULT(0),
            book_id integer NOT NULL DEFAULT(0),
            unit_id integer NOT NULL DEFAULT(0),
            question_type char(10),
            question text,
            option text,
            answer text,
            score integer(1),
            care_score integer(1) DEFAULT(0),
            step integer(1),
            backup integer(1),
            status integer(1) DEFAULT(0),
            wrong_count integer(2) DEFAULT(0),
            group_index integer(1) NOT NULL DEFAULT(0),
            invalid integer(1) DEFAULT(0),
            create_ts text(128) NOT NULL DEFAULT(datetime('now', 'localtime'))
        );
        """
        
        // 当前轮次表
        case currentTurn =
        """
        CREATE TABLE IF NOT EXISTS current_turn (
            current_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            study_id integer NOT NULL,
            word_id integer DEFAULT(0),
            step_id integer NOT NULL,
            step integer(1) NOT NULL DEFAULT(0),
            turn integer(2) NOT NULL DEFAULT(1),
            finish integer(1) NOT NULL DEFAULT(0),
            create_ts text(32) NOT NULL DEFAULT(datetime('now'))
        );
        """
    }
    
    
    // MARK: Update & Select
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
    
    enum ExerciseSQL: String {
        
        case insertExercise =
        """
        insert into
        all_exercise(
            study_id,
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
        values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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

        case getWordsCount =
        """
        SELECT count(*) count FROM all_exercise
        WHERE unfinish_count != 0 and is_new = ? and study_id = ?
        """

        case deleteExerciseWithStudy =
        """
        DELETE FROM all_exercise
        WHERE study_id = ?
        """
        
        case deleteExpiredExercise = "delete from all_exercise where date(create_ts) < date('now', 'localtime')"
        
        case deleteAllExercise = "delete from all_exercise"
    }
    
    
    enum WordStepSQL: String {
        
        case insertWordStep =
        """
        insert into
        all_word_step(
            study_id,
            exercise_id,
            word_id,
            book_id,
            unit_id,
        
            question_type,
            question,
            option,
            score,
            care_score,
        
            step,
            backup,
            group_index
        )
        values(
            ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?,
            ?, ?, ?
        )
        """

        case updateWordStep =
        """
        UPDATE all_word_step
        SET status =
        (SELECT CASE
            WHEN status = 1
            THEN 1
            ELSE ?
            END
        ),
        wrong_count = wrong_count + ?
        WHERE exercise_id = ? and step = ?
        """
        
        case selectUnfinishMinGroup =
        """
        select min(group_index) current_group from all_word_step
        where (status = 0 or status = 1) and study_id = ?
        """
        
        
        case selectWordStep =
        """
        select mastered, s.* from all_exercise e inner join all_word_step s
        on e.exercise_id = s.exercise_id
        where s.study_id = ? and s.word_id = ? and s.step = ?
        """
        
        case selectOriginalWordStepModelByBackup =
        """
        select mastered, s.* from all_exercise e inner join all_word_step s
        on e.exercise_id = s.exercise_id and s.backup = 0
        where s.study_id = ? and s.word_id = ? and s.step = ?
        """
        
        case selsetSteps =
        """
        SELECT * FROM all_word_step
        WHERE exercise_id = ? and step != 0
        """

        case skipStep1_4 =
        """
        UPDATE all_word_step
        SET status = 3
        WHERE exercise_id = ? and (step = 1 or step = 4)
        """

        case selectStep_4Count =
        """
        SELECT count(*) count FROM all_word_step
        WHERE exercise_id = ? and (step = 1 or step = 4)
        """
        
        case updatePreviousWrongStatus =
        """
        update all_word_step set status = 0 where step_id in (select step_id from current_turn where study_id = ?)
        and status = 1
        """
        
        case selectBackupStep =
        """
        select * from all_word_step
        where study_id = ? and exercise_id = ? and step = ? and backup = 1
        """
        
        case selectUnfinishMinStep =
        """
        select min(step) step from all_word_step
        where study_id = ? and group_index = ? and backup = 0
        and (status = 0 or status = 1)
        """
        
        case deleteStep =
        """
        DELETE FROM all_word_step
        WHERE exercise_id = ? and step = ? and score = ?
        """

        case deleteStepWithStudy =
        """
        DELETE FROM all_word_step
        WHERE study_id = ?
        """
        
        case deleteExpiredWordStep = "delete from all_word_step where date(create_ts) < date('now', 'localtime')"
        
        case deleteAllWordStep = "delete from all_word_step"

        case selectInfo =
         """
         SELECT * FROM all_word_step
         WHERE exercise_id = ? and step = ?
         """
        case selectExerciseStep =
        """
        SELECT * FROM all_word_step
        WHERE exercise_id = ?
        """
    }
    
    enum CurrentTurnSQL: String {
        
        case insertTurn =
        """
        insert into current_turn(study_id, word_id, step_id, step, turn)
        select study_id, word_id, step_id, min(step) step, (select current_turn from study_record where study_id = ? limit 1) turn from all_word_step
        where study_id = ? and group_index = ? and backup = 0
        and (status = 0 or status = 1) and turn >= step
        group by word_id
        order by step desc, exercise_id asc
        """
        
        /// 正常查询【未完成的】
        case selectExercise =
        """
        select c.current_id, s.* from current_turn c inner join all_word_step s
        on s.step_id = c.step_id and c.finish = 0 and c.study_id = ?
        order by c.current_id asc
        limit ?
        """
        
        /// 正常查询 【当前轮，包括完成和未完成】
        case selectCurrentTurn =
        """
        select c.current_id, c.finish finish, s.* from current_turn c inner join all_word_step s
        on s.step_id = c.step_id and c.study_id = ?
        order by c.current_id asc
        """
        
        /// 查询连线题
        case selectConnectionExercise =
        """
        select c.current_id, s.* from current_turn c inner join all_word_step s
        on s.step_id = c.step_id and c.finish = 0 and c.study_id = ?
        where question_type = ? and c.step = ?
        order by c.current_id asc
        limit ?
        """
        
        
        case selectTurnFinishStatus =
        """
        select count(*) = 0 finish from current_turn
        where finish = 0 and study_id = ?
        """
        
        /// 更新完成状态
        case updateFinish = "update current_turn set finish = 1 where step_id = ?"
        /// 更新完成状态，根据当前轮和单词ID
        case updateFinishByWordId = "update current_turn set finish = 1 where study_id = ? and word_id = ?"
        
        /// 删除当前轮
        case deleteCurrentTurn = "delete from current_turn where study_id = ?"
        
        /// 删除过期的轮
        case deleteExpiredTurn = "delete from current_turn where date(create_ts) < date('now', 'localtime')"
        
        /// 删除所有的轮
        case deleteAllTurn = "delete from current_turn"
        
        
        case updateError = ""
    }
}
