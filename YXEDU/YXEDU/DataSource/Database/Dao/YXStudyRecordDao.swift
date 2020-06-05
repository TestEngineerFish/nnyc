//
//  YXStudyRecordDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStudyRecordDao {
    
    func insertStudyRecord(type: YXExerciseRuleType, model: YXLearnConfig) -> Bool
    
    
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
    /// - Parameters:
    ///   - config: 学习配置信息
    func getStartTime(learn config: YXLearnConfig) -> Int

    /// 获得学习持续时间
    /// - Parameters:
    ///   - config: 学习配置信息
    func getDurationTime(learn config: YXLearnConfig) -> Int
    
}
