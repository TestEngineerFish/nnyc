//
//  YXExerciseDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXExerciseDao {

    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertExercise(type: YXExerciseRuleType, planId: Int?, exerciseModel: YXExerciseModel) -> Int

    /// 更新练习记录
    /// - Parameter model: 练习对象
    @discardableResult
    func updateExercise(exercise model: YXExerciseModel) -> Bool


    /// 获得当前学习流程的所有练习
    /// - Parameters:
    ///   - type: 学习类型
    ///   - id: 词单ID，可选
    func getAllExercise(type: YXLearnType, plan id: Int?) -> [YXExerciseModel]

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredExercise() -> Bool

    @discardableResult
    func deleteAllExercise() -> Bool

}

protocol YXWordStepDao {
    
    // TODO: ==== 查询 ====
    /// 查询练习数据
    /// - Parameter type: 单词类型【1.新学；2.训练；3.复习】
    func selectExercise(type: Int) -> YXExerciseModel?
    
    /// 查询连线题的备份数据
    /// - Parameter wordId: 单词Id
    func selectBackupExercise(wordId: Int, step: Int) -> YXExerciseModel?
    
    /// 查询练习进度
    func selectExerciseProgress() -> YXExerciseProgress
    
    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertWordStep(type: YXExerciseRuleType, exerciseModel: YXExerciseModel) -> Bool
    
    // TODO: ==== 修改/删除 ====
    /// 更新练习数据状态
    /// - Parameter exerciseModel: 练习
    @discardableResult
    func updateExercise(exerciseModel: YXExerciseModel) -> Bool

    /// 获取单词的所有已做的练习题，字典返回，用于上报
    /// - Parameter model: 练习对象
    /// - Returns: step结果和总的错误次数
    func getSteps(with model: YXExerciseModel) -> ([String:Any], Int)

    /// 删除某一个Step
    /// - Parameter model: 练习对象
    func deleteStep(with model: YXExerciseModel)
    
    /// 清除过期的数据
    @discardableResult
    func deleteExpiredWordStep() -> Bool
    
    func deleteAllWordStep() -> Bool
    /// 查询单词得分
    func selecteWordScore(exercise model: YXExerciseModel) -> Int
}



protocol YXAllExerciseDao {
    // 更新当前练习的数据
    func updateCurrentExercise(type: YXLearnType,bookId: Int, unitId: Int) -> Bool
    
    
    /// 删除当前练习的数据
    func deleteCurrentExercise() -> Bool
}



// TODO: ----------- 进度管理
protocol YXExerciseProgressDao {
    // TODO: ==== 查询 ====
    /// 查询错误次数
    func selectErrorCount(wordId: Int) -> Int
    
    // TODO: ==== 插入 ====
    /// 插入错误次数
    func insertErrorCount(wordId: Int) -> Bool
    
    // TODO: ==== 更新 ====
    /// update错误次数
    func updateErrorCount(wordId: Int) -> Bool
    
    // TODO: ==== 更新 ====
    /// update错误次数
    func deleteErrorCount(wordId: Int) -> Bool
}
