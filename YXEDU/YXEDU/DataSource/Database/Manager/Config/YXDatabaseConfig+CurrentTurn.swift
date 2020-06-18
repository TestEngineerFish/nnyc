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
        insert into current_turn_v1(study_id, word_id, step_id, step, turn)
        select study_id, word_id, step_id, min(step) step, (select current_turn_v1 from study_record_v1 where study_id = ? limit 1) turn from all_word_step
        where study_id = ? and group_index = ? and backup = 0
        and (status = 0 or status = 1) and turn >= step
        group by word_id
        order by step desc, exercise_id asc
        """

        /// 正常查询【未完成的】
        case selectExercise =
        """
        select c.current_id, s.* from current_turn_v1 c inner join all_word_step s
        on s.step_id = c.step_id and c.finish = 0 and c.study_id = ?
        order by c.current_id asc
        limit ?
        """

        /// 正常查询 【当前轮，包括完成和未完成】
        case selectCurrentTurn =
        """
        select c.current_id, c.finish finish, s.* from current_turn_v1 c inner join all_word_step_v1 s
        on s.step_id = c.step_id and c.study_id = ?
        order by c.current_id asc
        """

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
        case updateFinish = "update current_turn_v1 set finish = 1 where step_id = ?"
        /// 更新完成状态，根据当前轮和单词ID
        case updateFinishByWordId = "update current_turn_v1 set finish = 1 where study_id = ? and word_id = ?"

        /// 删除当前轮
        case deleteCurrentTurn = "delete from current_turn_v1 where study_id = ?"

        /// 删除过期的轮
        case deleteExpiredTurn = "delete from current_turn_v1 where date(create_ts) < date('now', 'localtime')"

        /// 删除所有的轮
        case deleteAllTurn = "delete from current_turn_v1"


        case updateError = ""
    }
}
