//
//  YXStudyRecordDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStudyRecordDao {
    
    // 查询学习记录对象
    func selectStudyRecordModel(config: YXLearnConfig) -> YXStudyRecordModel?

    /// 插入学习记录
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - type: 学习规则
    @discardableResult
    func insertStudyRecord(learn config: YXLearnConfig, type: YXExerciseRule, turn: Int) -> Int

    /// 跟新当前组下标
    @discardableResult
    func updateCurrentGroup(studyId: Int, group: Int) -> Bool

    /// 更新学习进度
    /// - Parameters:
    ///   - studyId: 哪个学习
    ///   - progress: 进度
    func updateProgress(studyId: Int, progress: YXExerciseProgress) -> Bool
    
    /// 更新当前轮下标
    /// - Parameters:
    ///   - config:
    ///   - turn:
    func updateCurrentTurn(studyId: Int, turn: Int?) -> Bool

    /// 添加学习次数
    func addStudyCount(studyId: Int)

    /// 设置开始学习时间
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - time: 开始学习时间
    func setStartTime(studyId: Int)


    /// 更新学习持续时长
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - time: 持续时长
    func setDurationTime(studyId: Int, duration time: Int)

    /// 获得开始学习时间
    /// - Parameter config: 学习配置信息
    func getStartTime(learn config: YXLearnConfig) -> String

    /// 获得学习持续时间
    /// - Parameter config: 学习配置信息
    func getDurationTime(learn config: YXLearnConfig) -> Int

    /// 删除学习记录
    /// - Parameter id: 学习记录的ID
    @discardableResult
    func delete(study id: Int) -> Bool
        
    /// 删除过期的学习记录
    func deleteExpiredStudyRecord() -> Bool

    func deleteAllStudyRecord() -> Bool
    
}
