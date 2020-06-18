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

    /// 获得新学单词列表
    /// - Parameter id: 学习流程ID
    func getNewWordList(study id: Int) -> [YXWordModel]

    /// 获得复习单词列表
    /// - Parameter id: 学习流程ID
    func getReviewWordList(study id: Int) -> [YXWordModel]

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

//    /// 更新未做题数
//    /// - Parameters:
//    ///   - id: 练习ID
//    ///   - reduceCount: 减少数量
//    @discardableResult
//    func updateUnfinishedCount(exercise id: Int, reduceCount: Int) -> Bool

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





