//
//  YXStudyRecordDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStudyRecordDao {

    /// 获得学习记录的ID
    /// - Parameter config: 学习配置信息
    /// - Returns: 记录ID
    func getStudyID(learn config: YXLearnConfig) -> Int

    /// 插入学习记录
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - type: 学习规则
    func insertStudyRecord(learn config: YXLearnConfig, type: YXExerciseRuleType) -> Bool

    /// 设置开始学习时间
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - time: 开始学习时间
    func setStartTime(learn config: YXLearnConfig, start time: Int)

    /// 更新学习持续时长
    /// - Parameters:
    ///   - config: 学习配置信息
    ///   - time: 持续时长
    func setDurationTime(learn config: YXLearnConfig, duration time: Int)

    /// 获得开始学习时间
    /// - Parameter config: 学习配置信息
    func getStartTime(learn config: YXLearnConfig) -> Int

    /// 获得学习持续时间
    /// - Parameter config: 学习配置信息
    func getDurationTime(learn config: YXLearnConfig) -> Int

    /// 删除学习记录
    /// - Parameter id: 学习记录的ID
    func delete(study id: Int)
}
