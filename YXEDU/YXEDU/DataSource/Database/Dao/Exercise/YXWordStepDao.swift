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
    /// 查询当前未学完的分组下标，nil 分组说明学完了
    func selectCurrentGroup(studyId: Int) -> Int?
    
    /// 查找当前组(group)未做的最小step
    /// - Parameter studyId:
//    func selectUnFinishMinStep(studyId: Int, group: Int) -> Int?
    func selectUnFinishMinStep(studyRecord: YXStudyRecordModel) -> Int?

    /// 查询一个 练习对象 （当前仅用在了连线题中，查单个的model）
    func selectWordStepModel(studyId: Int, wordId: Int, step: Int) -> YXExerciseModel?
    
    /// 根据备选查原始对象
    func selectOriginalWordStepModelByBackup(studyId: Int, wordId: Int, step: Int) -> YXExerciseModel?
    
    // TODO: ==== 插入 ====add
    /// 添加练习数据
    /// - Parameter exerciseModel: 练习
    func insertWordStep(study recordId: Int, exerciseModel: YXExerciseModel) -> Bool
    
    // TODO: ==== 修改/删除 ====
    /// 更新练习数据状态
    /// - Parameter exerciseModel: 练习
    @discardableResult
    func updateStep(exerciseModel: YXExerciseModel) -> Bool

    /// 跳过Step1-4
    /// - Parameter model: 练习对象
    func skipStep1_4(exercise model: YXExerciseModel) -> Bool

    
    /// 上一轮做错的状态，重置为未做（status  = 0）
    func updatePreviousWrongStatus(studyId: Int) -> Bool
    
    /// 获取单词的所有已做的练习题，字典返回，用于上报
    /// - Parameter model: 练习对象
    /// - Returns: step结果
    func getReportSteps(with model: YXExerciseModel) -> [String:Any]

    /// 删除某一个Step
    /// - Parameter model: 练习对象
    func deleteStep(with model: YXExerciseModel)

    /// 删除一个学习记录的所有学习步骤
    /// - Parameter id: 学习记录ID
    @discardableResult
    func deleteStepWithStudy(study id: Int) -> Bool

    /// 清除过期的数据
    @discardableResult
    func deleteExpiredWordStep() -> Bool
    
    func deleteAllWordStep() -> Bool
    /// 查询单词得分
    func selecteWordScore(exercise model: YXExerciseModel) -> Int

    /// 获得一个Step的状态
    /// - Parameter model: 练习对象
    func getStepStatus(exercise model: YXExerciseModel) -> YXStepStatus
}
