//
//  YXWordStepDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXWordStepDao {

    // TODO: ==== 插入 ====add

    /// 添加练习数据
    /// - Parameters:
    ///   - studyId: 学习记录ID
    ///   - exerciseId: 练习记录ID
    ///   - wordModel: 单词对象
    ///   - stepModel: 练习步骤对象
    @discardableResult
    func insertWordStep(studyId: Int, exerciseId: Int, wordModel: YXWordModel, stepModel: YXExerciseStepModel) -> Bool
    
    // TODO: ==== 修改/删除 ====

    /// 更新练习数据状态
    /// - Parameters:
    ///   - status: 状态
    ///   - id: 练习步骤ID
    ///   - count: 增加错误数
    @discardableResult
    func updateStep(status: YXStepStatus, step id: Int, wrong count: Int) -> Bool

    /// 获取单词的所有已做的练习题，字典返回，用于上报
    /// - Parameter id: 练习表ID
    func getReportSteps(exercise id: Int) -> [String:Int]

    /// 删除一个学习记录的所有学习步骤
    /// - Parameter id: 学习记录ID
    @discardableResult
    func deleteStepWithStudy(study id: Int) -> Bool

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredWordStep() -> Bool

    /// 删除所有的练习步骤
    func deleteAllWordStep() -> Bool

    /// 获得一个练习单词的总错误数
    /// - Parameter model: 练习表ID
    func getExerciseWrongAmount(exercise id: Int) -> Int
}
