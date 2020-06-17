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
    func insertExercise(learnType: YXLearnType, study recordId: Int, wordModel: YXWordModel, nextStep: String) -> Int

    /// 获得单词是否已掌握
    /// - Parameter id: 练习ID
    func getExerciseMastered(exercise id: Int) -> Bool

    /// 更新练习得分
    /// - Parameter id: 练习ID
    /// - Parameter reduceScore: 减少分数
    @discardableResult
    func updateScore(exercise id: Int, reduceScore: Int) -> Bool

    /// 更新未做题数
    /// - Parameters:
    ///   - id: 练习ID
    ///   - reduceCount: 减少数量
    @discardableResult
    func updateUnfinishedCount(exercise id: Int, reduceCount: Int) -> Bool

    /// 更新是否掌握状态
    /// - Parameters:
    ///   - id: 练习ID
    ///   - isMastered: 是否掌握
    @discardableResult
    func updateMastered(exercise id: Int, isMastered: Bool) -> Bool
    
    /// 获得当前学习流程的练习数量
    /// - Parameters:
    ///   - config: 练习对象
    ///   - includeNewWord: 是否包含新学
    ///   - includeReviewWord: 是否包含复习
    func getExerciseCount(studyId: Int, includeNewWord: Bool, includeReviewWord: Bool) -> Int
    
    /// 获得当前学习流程的所有练习
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - includeNewWord: 是否包含新学单词
    ///   - includeReviewWord: 是否包含复习单词
    func getExerciseList(studyId: Int, includeNewWord: Bool, includeReviewWord: Bool) -> [YXExerciseModel]

    /// 获取未学完的新学单词数量
    func getUnfinishedNewWordAmount(study id: Int) -> Int

    /// 获取已学完的新学单词数量
    func getFinishedNewWordAmount(study id: Int) -> Int

    /// 获取未学完的复习单词数量
    func getUnfinishedReviewWordAmount(study id: Int) -> Int

    /// 获取已学完的复习单词数量
    func getFinishedReviewWordAmount(study id: Int) -> Int

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





