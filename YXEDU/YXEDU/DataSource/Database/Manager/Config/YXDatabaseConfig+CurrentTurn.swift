//
//  YXDatabaseConfig+CurrentTurn.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YYSQLManager {
    enum CurrentTurnSQL: String {

        case insertTurn =
        """
        INSERT INTO current_turn_v1(study_id, step_id)
        SELECT s.study_id study_id, s.step_id
        FROM all_exercise_v1 as e
        JOIN all_word_step_v1 as s on e.exercise_id = s.exercise_id
        WHERE e.study_id = ? and e.next_step = s.step
        ORDER by e.exercise_id
        """


        /// 正常查询【未完成的】
        case selectExercise =
        """
        SELECT c.current_id, s.*, e.*
        FROM current_turn_v1 c
        INNER JOIN all_word_step_v1 s
        INNER JOIN all_exercise_v1 e
        ON s.step_id = c.step_id AND c.finish = 0 AND c.study_id = ? AND e.exercise_id = s.exercise_id
        ORDER BY c.current_id ASC
        LIMIT ?
        """

//        /// 正常查询 【当前轮，包括完成和未完成】
//        case selectCurrentTurn =
//        """
//        select c.current_id, c.finish finish, s.* from current_turn_v1 c inner join all_word_step_v1 s
//        on s.step_id = c.step_id and c.study_id = ?
//        order by c.current_id asc
//        """

        /// 查询连线题
        case selectConnectionExercise =
        """
        select c.current_id, s.* from current_turn_v1 c inner join all_word_step_v1 s
        on s.step_id = c.step_id and c.finish = 0 and c.study_id = ?
        where question_type = ? and c.step = ?
        order by c.current_id asc
        limit ?
        """


        case selectTurnFinishStatus =
        """
        select count(*) = 0 finish from current_turn_v1
        where finish = 0 and study_id = ?
        """

        /// 更新完成状态
        case updateFinish =
        """
        UPDATE current_turn_v1
        SET finish = 1
        WHERE step_id = ?
        """

        /// 更新完成状态，根据当前轮和单词ID
        case updateFinishByWordId = "update current_turn_v1 set finish = 1 where study_id = ? and word_id = ?"

        /// 删除当前轮
        case deleteCurrentTurn =
        """
        DELETE FROM current_turn_v1
        WHERE study_id = ?
        """

        /// 删除过期的轮
        case deleteExpiredTurn = "delete from current_turn_v1 where date(create_ts) < date('now', 'localtime')"

        /// 删除所有的轮
        case deleteAllTurn = "delete from current_turn_v1"


        case updateError = ""
    }
}
