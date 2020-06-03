//
//  YXExerciseServiceImpl+Build.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 出题逻辑，从数据库读取数据
extension YXExerciseServiceImpl {
    func queryExerciseModel() -> YXWordExerciseModel? {
        
        if learnConfig.learnType != .base {
            
        }
        
        
        if let exercise = stepDao.selectExercise(type: YXExerciseWordType.new.rawValue) {
            return exercise
        } else if let exercise = stepDao.selectExercise(type: YXExerciseWordType.exercise.rawValue) {
            return exercise
        } else if let exercise = stepDao.selectExercise(type: YXExerciseWordType.review.rawValue) {
            return exercise
        }
        return nil
    }

    // MARK: ==== Tools ====

    /// 更新得分
    func updateScore(exercise model: YXWordExerciseModel) -> YXWordExerciseModel {

        var _model      = model
        let isDouble    = model.power == 10
        let step1Deduct = 3
        let step2Deduct = isDouble ? 4 : 2
        let step3Deduct = isDouble ? 2 : 1
        let step4Deduct = 1

        switch model.step {
        case 1:
            _model.score -= model.result == true ? 0 : step1Deduct
        case 2:
            _model.score -= model.result == .some(true) ? 0 : step2Deduct
        case 3:
            _model.score -= model.result == .some(true) ? 0 : step3Deduct
        case 4:
            _model.score -= model.result == .some(true) ? 0 : step4Deduct
        default:
            break
        }

        _model.score = _model.score < 0 ? 0 : _model.score
        // 更新单词得分
        return _model
    }

    /// 更新、保存Step到数据库
    func saveStep(exercise model: YXWordExerciseModel) {
        // 数据库操作 - 保存数据
        if model.result == .some(true) {
            // 更新练习表对应单词的剩余步骤
        }
    }

    /// 更新进度
    func updateProgress(exercise model: YXWordExerciseModel) {
        if model.result == .some(true) {
            // 数据库操作 - 查询数据库中是否有未完成的其他Step题型
            let haveSteps = Int.random(in: -8...10) > 0
            if haveSteps {
                return
            } else {
                if model.isNewWord {
                    // 数据库操作 - 更新新学单词数
                } else {
                    // 数据库操作 - 更新复习单词数
                }
            }
        }
    }
}
