//
//  YXWordStepDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXWordStepDao {
    
    // TODO: ==== 查询 ====
//    /// 查询练习数据
//    /// - Parameter type: 单词类型【1.新学；2.训练；3.复习】
//    func selectExercise(type: Int) -> YXExerciseModel?
//
//    /// 查询连线题的备份数据
//    /// - Parameter wordId: 单词Id
//    func selectBackupExercise(wordId: Int, step: Int) -> YXExerciseModel?
    
    /// 查询练习进度
    func selectExerciseProgress() -> YXExerciseProgress
    
    /// 查找当前组(group)未做的最小step
    /// - Parameter studyId:
    func selectUnFinishMinStep(studyId: Int, group: Int) -> Int?
    
    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertWordStep(type: YXExerciseRuleType, study recordId: Int, exerciseModel: YXExerciseModel) -> Bool
    
    // TODO: ==== 修改/删除 ====
    /// 更新练习数据状态
    /// - Parameter exerciseModel: 练习
    @discardableResult
    func updateStep(exerciseModel: YXExerciseModel) -> Bool

    /// 获取单词的所有已做的练习题，字典返回，用于上报
    /// - Parameter model: 练习对象
    /// - Returns: step结果和总的错误次数
    func getSteps(with model: YXExerciseModel) -> ([String:Any], Int)

    /// 删除某一个Step
    /// - Parameter model: 练习对象
    func deleteStep(with model: YXExerciseModel)

    /// 删除一个学习记录的所有学习步骤
    /// - Parameter id: 学习记录ID
    func deleteStepWithStudy(study id: Int) -> Bool

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredWordStep() -> Bool
    
    func deleteAllWordStep() -> Bool
    /// 查询单词得分
    func selecteWordScore(exercise model: YXExerciseModel) -> Int
}
