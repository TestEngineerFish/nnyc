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

    /// 更新缓存表
    func updateCurrentTurn(exercise model: YXExerciseModel) {
        let isValidationType =  (model.type == .validationWordAndChinese || model.type == .validationImageAndWord)
        
        // 做对或者判断题，才改完成状态【做题时，做错一次，立即退出学习，如果改了状态，下次进来当前轮就没法做了】
        if model.status == .right || isValidationType {
            self.turnDao.updateExerciseFinishStatus(stepId: model.stepId)
        }
    }

    /// 更新Step数据库
    func updateStep(exercise model: YXExerciseModel) {
        self.stepDao.updateStep(exerciseModel: model)
    }

    /// 跳过Step1-4
    @discardableResult
    func skipStep1_4(exercise model: YXExerciseModel) -> Bool {
        let result = self.stepDao.skipStep1_4(exercise: model)
        // 获得跳过的数量(仅支持跳过一次，多次跳过不支持)
        let count = self.stepDao.getStep1_4Count(exercise: model.eid)
        // 减少Exercise的未做题数
        self.exerciseDao.updateUnfinishedCount(exercise: model.eid, reduceCount: count)
        return result
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

    /// 移除0分或者7分题
    /// - Parameter model: 练习对象
    func removeScore0_7Step(exercise model: YXExerciseModel) {
        // 查询这个单词是否有0、7分题
        for index in (1...4) {
            let amount = self.stepDao.getStepCount(exercise: model.eid, step: index)
            if amount > 1 {
                // 如果有，删除一题
                var deleteModel = model
                deleteModel.mastered = !model.mastered
                deleteModel.step     = index
                YXLog(model.mastered ? "已" : "未", "掌握，移除", model.mastered ? "0":"7", "分题")
                self.stepDao.deleteStep(with: deleteModel)
            }
        }
    }

    /// 扣分逻辑
    private func getReduceScore(exercise model: YXExerciseModel) -> Int {
        let isMastered  = self.exerciseDao.getExerciseMastered(exercise: model.eid)
        var reduceScore = 0
        let step1Deduct = 3
        let step2Deduct = isMastered ? 4 : 2
        let step3Deduct = isMastered ? 2 : 1
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

