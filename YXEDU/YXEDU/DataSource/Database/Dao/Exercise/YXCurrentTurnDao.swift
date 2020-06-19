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
    @discardableResult
    func insertCurrentTurn(study id: Int) -> Bool

    /// 下一轮是否含有N3题型
    /// - Parameter id: 学习流程ID
    func nextTurnHasN3Question(study id: Int) -> Bool

    /// 插入所有未做的N3题型
    /// - Parameter id: 学习流程ID
    @discardableResult
    func insertAllN3Step(study id: Int) -> Bool

    /// 正常获取首个未做的练习
    func selectExercise(study id: Int) -> YXExerciseModel?
    
    /// 获得当前轮的所有数据【未完成的】
    func selectAllExercise(study id: Int) -> [YXExerciseModel]

    /// 当前轮是否都完成
    func selectTurnFinishStatus(study id: Int) -> Bool
    
    /// 更新完成状态
    @discardableResult
    func updateExerciseFinishStatus(step id: Int) -> Bool
    
    /// 删除当前练习的数据
    func deleteCurrentTurn(study id: Int) -> Bool
    
    /// 删除过期的轮
    func deleteExpiredTurn() -> Bool

    /// 删除所有轮
    func deleteAllExpiredTurn() -> Bool
}
