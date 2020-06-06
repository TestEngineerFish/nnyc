//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXCurrentTurnDao {
    
    
    /// 插入当前轮的数据
    func insertCurrentTurn() -> Bool
    
    
    /// 正常获取首个未做的练习
    func selectExercise() -> YXExerciseModel?
    
    /// 获取连线题
    func selectExercise(step: Int, type: YXQuestionType) -> [YXExerciseModel]
    
    ///获取备选题型
    func selectBackupExercise(exerciseId: Int, step: Int) -> YXExerciseModel?
    
    /// 当前未做的第一个，是否为连线题，返回 type 和 step
    func selectConnectionType() -> (YXQuestionType, Int)?

    /// 当前轮是否都完成
    func selectTurnFinishStatus() -> Bool
    
    /// 更新完成状态
    func updateExerciseFinishStatus(stepId: Int) -> Bool
    
    
    /// 删除当前练习的数据
    func deleteCurrentTurn() -> Bool
}
