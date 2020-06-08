//
//  YXExerciseServiceImpl+Update.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 做题后修改状态
extension YXExerciseServiceImpl {

    func clearExpiredData() {
        let r1 = studyDao.deleteExpiredStudyRecord()
        let r2 = exerciseDao.deleteExpiredExercise()
        let r3 = stepDao.deleteExpiredWordStep()
        let r4 = turnDao.deleteExpiredTurn()
        
        YXLog("删除过期的学习记录", r1, r2, r3, r4)
    }

    /// 更新缓存表
    func updateCurrentTurn(exercise model: YXExerciseModel) {
        self.turnDao.updateExerciseFinishStatus(stepId: model.stepId)
    }

    /// 更新Step数据库
    func updateStep(exercise model: YXExerciseModel) {
        self.stepDao.updateStep(exerciseModel: model)
    }

    /// 跳过Step1-4
    @discardableResult
    func skipStep1_4(exercise model: YXExerciseModel) -> Bool {
        self.stepDao.skipStep1_4(exercise: model)
    }

    /// 减少未做Step的数量
    func updateExercise(exercise model: YXExerciseModel) {
        if model.status == .right {
            // 是否做过
            let status = self.stepDao.getStepStatus(exercise: model)
            let count = status == .some(.wrong) ? 0 : 1
            if count > 0 {
                self.exerciseDao.updateUnfinishedCount(exercise: model.eid, reduceCount: count)
            }
            if model.step == 0 {
                self.exerciseDao.updateMastered(exercise: model.eid, isMastered: model.mastered)
            }
        } else {
            let reduceScore = self.getReduceScore(exercise: model)
            self.exerciseDao.updateScore(exercise: model.eid, reduceScore: reduceScore)
            YXLog("做错扣-\(reduceScore)分")
        }
    }

    /// 扣分逻辑
    private func getReduceScore(exercise model: YXExerciseModel) -> Int {
        var reduceScore = 0
        let step1Deduct = 3
        let step2Deduct = model.mastered ? 4 : 2
        let step3Deduct = model.mastered ? 2 : 1
        let step4Deduct = 1
        switch model.step {
        case 1:
            reduceScore = model.status == .right ? 0 : step1Deduct
        case 2:
            reduceScore = model.status == .right ? 0 : step2Deduct
        case 3:
            reduceScore = model.status == .right ? 0 : step3Deduct
        case 4:
            reduceScore = model.status == .right ? 0 : step4Deduct
        default:
            break
        }
        return reduceScore
    }

    
}

