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

    func _clearExpiredData() {
        let r1 = studyDao.deleteExpiredStudyRecord()
        let r2 = exerciseDao.deleteExpiredExercise()
        let r3 = stepDao.deleteExpiredWordStep()
        let r4 = turnDao.deleteExpiredTurn()
        
        YXLog("删除过期的学习记录", r1, r2, r3, r4)
    }

    /// 当前轮完成后，不是删除数据，而且是改变状态为true
    func updateCurrentTurn(exercise model: YXExerciseModel) {
        self.turnDao.updateExerciseFinishStatus(step: model.stepId)
    }

    /// 更新Step数据库
    func updateStep(exercise model: YXExerciseModel) {
        let wrongCount = (isNewLearn(question: model.type) || model.status == .right) ? 0 : 1
        self.stepDao.updateStep(status: model.status, step: model.stepId, wrong: wrongCount)
    }

    func updateExercise(exercise model: YXExerciseModel) -> Bool {
        var stepEnd = false
        if isNewLearn(question: model.type) {
            guard let ruleModel = model.ruleModel else {
                return stepEnd
            }
            let nextStep = ruleModel.getNextStep(isRight: model.status == .right)
            self.exerciseDao.updateNextStep(exercise: model.eid, next: nextStep)
        } else {
            if model.status == .right {
                // 更新NextStep
                guard let ruleModel = model.ruleModel else {
                    return stepEnd
                }
                let nextStep = ruleModel.getNextStep(isRight: model.wrongCount == 0)
                stepEnd = nextStep == "END" ? true : false
                self.exerciseDao.updateNextStep(exercise: model.eid, next: nextStep)
            } else {
                // 更新得分
                let score = Int(abs(model.operate?.errorScore ?? 0))
                self.exerciseDao.updateScore(exercise: model.eid, reduce: score)
                YXLog("做错扣-\(score)分")
            }
        }
        return stepEnd
    }
}

