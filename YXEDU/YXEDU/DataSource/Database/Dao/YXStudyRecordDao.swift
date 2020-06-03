//
//  YXStudyRecordDao.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXStudyRecordDao {

    /// 设置开始学习时间
    /// - Parameters:
    ///   - type: 学习类型
    ///   - id: 词单ID，可选
    ///   - time: 开始学习时间
    func setStartTime(type: YXExerciseDataType, plan id: Int?, start time: Int)

    /// 更新学习持续时长
    /// - Parameters:
    ///   - type: 学习类型
    ///   - id: 词单ID，可选
    ///   - time: 持续时长
    func updateDurationTime(type: YXExerciseDataType, plan id: Int?, duration time: Int)

    /// 获得开始学习时间
    /// - Parameters:
    ///   - type: 学习类习
    ///   - id: 词单ID，可选
    func getStartTime(type: YXExerciseDataType, plan id: Int?) -> Int
    
}
