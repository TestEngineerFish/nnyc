//
//  YXStudyRecordDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStudyRecordDao {

    /// 插入学习记录
    /// - Parameters:
    ///   - config: 学习配置信息
    /// - Parameter newWordCount: 总新学单词数量
    /// - Parameter reviewWordCount: 总复习单词数量
    @discardableResult
    func insertStudyRecord(learn config: YXLearnConfig, newWordCount: Int, reviewWordCount: Int) -> Int

    /// 查询学习记录对象
    /// - Parameter config: 学习配置信息
    func selectStudyRecordModel(learn config: YXLearnConfig) -> YXStudyRecordModel?

    /// 查询学习次数
    /// - Parameter config: 学习配置信息
    func selectStudyCount(learn config: YXLearnConfig) -> Int

    /// 更新学习进度
    /// - Parameters:
    ///   - ID: 学习流程ID
    ///   - progress: 进度
    @discardableResult
    func updateProgress(study id: Int, progress: YXExerciseProgress) -> Bool

    /// 重置学习记录
    /// - Parameter id: 学习流程ID
    func reset(study id: Int) -> Bool

    /// 添加学习次数
    /// - Parameter id: 学习记录ID
    func addStudyCount(study id: Int)

    /// 设置开始学习时间
    /// - Parameter id: 学习记录ID
    func setStartTime(study id: Int)

    /// 获取主流程当天的最后一次开始学习的时间
    func getBaseStudyLastStartTime() -> Date?

    /// 更新学习持续时长
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - time: 持续时长
    func setDurationTime(study id: Int, duration time: Int)

    /// 获得开始学习时间
    /// - Parameter config: 学习配置信息
    func getStartTime(learn config: YXLearnConfig) -> String

    /// 获得学习持续时间
    /// - Parameter config: 学习配置信息
    func getDurationTime(learn config: YXLearnConfig) -> Int
    
    /// 获得新单词数量
    /// - Parameter id: 学习Id
    func getNewWordCount(study id: Int) -> Int
    
    /// 获得复习单词数量
    /// - Parameter id: 学习Id
    func getReviewWordCount(study id: Int) -> Int

    /// 删除学习记录
    /// - Parameter id: 学习记录的ID
    @discardableResult
    func delete(study id: Int) -> Bool
        
    /// 删除过期的学习流程记录
    func deleteExpiredStudyRecord() -> Bool

    /// 删除所有学习流程记录
    func deleteAllStudyRecord() -> Bool
    
}
