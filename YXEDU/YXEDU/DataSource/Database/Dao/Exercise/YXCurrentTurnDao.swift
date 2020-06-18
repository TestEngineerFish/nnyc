//
//  YXCurrentTurnDao.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

protocol YXCurrentTurnDao {
    
    /// 插入当前轮的数据
    func insertCurrentTurn(studyId: Int) -> Bool

    /// 正常获取首个未做的练习
    func selectExercise(studyId: Int) -> YXExerciseModel?
    
    /// 获得当前轮的所有数据【未完成的】
    func selectAllExercise(studyId: Int) -> [YXExerciseModel]
    
//    /// 获得当前轮的所有数据[【包含完成和未完成，仅用于打印】
//    func selectCurrentTurn(studyId: Int) -> [YXExerciseModel]
    
    /// 获取连线题
    func selectExercise(studyId: Int, type: YXQuestionType, step: Int, size: Int) -> [YXExerciseModel]
    
    ///获取备选题型
    func selectBackupExercise(studyId: Int, exerciseId: Int, step: Int) -> YXExerciseModel?

    /// 当前轮是否都完成
    func selectTurnFinishStatus(studyId: Int) -> Bool
    
    /// 更新完成状态
    @discardableResult
    func updateExerciseFinishStatus(stepId: Int) -> Bool
    @discardableResult
    func updateExerciseFinishStatus(studyId: Int, wordId: Int) -> Bool
    
    
    /// 删除当前练习的数据
    func deleteCurrentTurn(studyId: Int) -> Bool
    
    /// 删除过期的轮
    func deleteExpiredTurn() -> Bool

    /// 删除所有轮
    func deleteAllExpiredTurn() -> Bool
}
