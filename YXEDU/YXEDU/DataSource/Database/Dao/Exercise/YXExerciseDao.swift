//
//  YXExerciseDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit



protocol YXExerciseDao {

    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertExercise(type: YXExerciseRuleType, planId: Int?, exerciseModel: YXExerciseModel) -> Int

    /// 更新练习记录
    /// - Parameter model: 练习对象
    @discardableResult
    func updateExercise(exercise model: YXExerciseModel) -> Bool


    /// 获得当前学习流程的所有练习
    /// - Parameters:
    ///   - type: 学习类型
    ///   - id: 词单ID，可选
    func getAllExercise(type: YXLearnType, plan id: Int?) -> [YXExerciseModel]

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredExercise() -> Bool

    @discardableResult
    func deleteAllExercise() -> Bool

}





