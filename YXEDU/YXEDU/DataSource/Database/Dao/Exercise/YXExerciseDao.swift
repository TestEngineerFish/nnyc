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
    ///   - wordModel: 单词对象
    @discardableResult
    func insertExercise(learn type: YXLearnType, study id: Int, word model: YXWordModel, next step: String) -> Int

    /// 获得新学单词列表
    /// - Parameter id: 学习流程ID
    func getNewWordList(study id: Int) -> [YXWordModel]

    /// 获得复习单词列表
    /// - Parameter id: 学习流程ID
    func getReviewWordList(study id: Int) -> [YXWordModel]

    /// 获得所有单词数量
    /// - Parameter id: 学习流程ID
    func getAllWordExerciseAmount(study id: Int) -> Int

    /// 更新Next Step
    /// - Parameters:
    ///   - id: 练习记录ID
    ///   - step: 下一步Step
    @discardableResult
    func updateNextStep(exercise id: Int, next step: String) -> Bool

    /// 更新练习得分
    /// - Parameters:
    ///   - id: 练习ID
    ///   - score: 减少分数
    @discardableResult
    func updateScore(exercise id: Int, reduce score: Int) -> Bool

    /// 获得当前学习流程中的所有对象，用于上报
    /// - Parameter id: 学习流程ID
    func getAllExerciseList(study id: Int) -> [YXExerciseReportModel]

    /// 删除一个学习记录所有单词
    /// - Parameter id: 学习记录ID
    @discardableResult
    func deleteExercise(study id: Int) -> Bool

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredExercise() -> Bool

    @discardableResult
    func deleteAllExercise() -> Bool

}





