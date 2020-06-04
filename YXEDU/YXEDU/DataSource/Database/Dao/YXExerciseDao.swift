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
    func insertExercise(type: YXExerciseRuleType, planId: Int?, exerciseModel: YXWordExerciseModel) -> Int
    
    
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
    func selectExercise(type: Int) -> YXWordExerciseModel?
    
    /// 查询连线题的备份数据
    /// - Parameter wordId: 单词Id
    func selectBackupExercise(wordId: Int, step: Int) -> YXWordExerciseModel?
    
    /// 查询练习进度
    func selectExerciseProgress() -> YXExerciseProgress
    
    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertWordStep(type: YXExerciseRuleType, exerciseModel: YXWordExerciseModel) -> Bool
    
    // TODO: ==== 修改/删除 ====
    /// 更新练习数据状态
    /// - Parameter exerciseModel: 练习
    func updateExercise(exerciseModel: YXWordExerciseModel) -> Bool
    
    /// 删除所有学习数据【1.学习完，2.第二天清除，3.清除缓存】
//    func deleteExercise() -> Bool
    
    
    /// 清除过期的数据
    @discardableResult
    func deleteExpiredWordStep() -> Bool
    
    func deleteAllWordStep() -> Bool
    /// 查询单词得分
    func selecteWordScore(exercise model: YXWordExerciseModel) -> Int
}



protocol YXAllExerciseDao {
    // 更新当前练习的数据
    func updateCurrentExercise(type: YXExerciseDataType,bookId: Int, unitId: Int) -> Bool
    
    
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
