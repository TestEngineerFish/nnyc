//
//  YXExerciseDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit



protocol YXExerciseDao {

    /// 添加练习数据
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - exerciseModel: 练习对象
    func insertExercise(learn config: YXLearnConfig, rule: YXExerciseRuleType, study recordId: Int, exerciseModel: YXExerciseModel) -> Int

    /// 更新练习记录
    /// - Parameter model: 练习对象
    @discardableResult
    func updateExercise(exercise model: YXExerciseModel) -> Bool

    /// 获得当前学习流程的所有练习
    /// - Parameter config: 学习配置信息
    func getAllExercise(learn config: YXLearnConfig) -> [YXExerciseModel]

    /// 删除一个学习记录所有单词
    /// - Parameter id: 学习记录ID
    func deleteExercise(study id: Int)

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredExercise() -> Bool

    @discardableResult
    func deleteAllExercise() -> Bool

}





