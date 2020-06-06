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
    @discardableResult
    func insertExercise(learn config: YXLearnConfig, rule: YXExerciseRuleType, study recordId: Int, exerciseModel: YXExerciseModel) -> Int

    /// 更新练习记录
    /// - Parameter model: 练习对象
    @discardableResult
    func updateExercise(exercise model: YXExerciseModel) -> Bool
    
    /// 获得新学单词数量
    /// - Parameter config: 学习配置信息
    func getNewWordCount(learn config: YXLearnConfig) -> Int
    
    /// 获得复习单词数量
    /// - Parameter config: 学习配置信息
    func getReviewWordCount(learn config: YXLearnConfig) -> Int
    
    /// 获得当前学习流程的所有练习数量
    /// - Parameter config: 练习对象
    func getAllExerciseCount(learn config: YXLearnConfig) -> Int
    
    /// 获得当前学习流程的所有练习
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - includeNewWord: 是否包含新学单词
    ///   - includeReviewWord: 是否包含复习单词
    func getExerciseList(learn config: YXLearnConfig, includeNewWord: Bool, includeReviewWord: Bool) -> [YXExerciseModel]

    /// 删除一个学习记录所有单词
    /// - Parameter id: 学习记录ID
    func deleteExercise(study id: Int) -> Bool

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredExercise() -> Bool

    @discardableResult
    func deleteAllExercise() -> Bool

}





