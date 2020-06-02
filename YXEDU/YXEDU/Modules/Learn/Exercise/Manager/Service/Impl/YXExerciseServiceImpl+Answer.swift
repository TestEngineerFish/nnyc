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
        exerciseDao.deleteExpiredExercise()
        stepDao.deleteExpiredWordStep()
    }

    //MARK:  ----- update data
        /// 做题动作，不管答题对错，都需要调用次方法修改相关状态（连线题单个选项的对错有其他的方法处理）
        /// - Parameters:
        ///   - exerciseModel: 练习数据
        ///   - right: 对错
        func normalAnswerAction(exercise model: YXWordExerciseModel, right: Bool) {

            // 更新每个练习的完成状态
            self.updateStep(exercise: model)
//            updateNormalExerciseFinishStatus(exerciseModel: exerciseModel, right: right)
//
//            // 更新积分
//            updateQuestionTypeScore(exerciseModel: exerciseModel)
//            updateWordScore(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right, type: exerciseModel.type, isDouble: exerciseModel.power == 10)
//
//            // 更新对错
//            updateStepRightOrWrongStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right)
//
//            // 更新进度状态
//            progressManager.updateProgress(newWordArray: newWordArray, reviewWordArray: reviewWordArray)

            // 打印
    //        printStatus()

        }

        /// 连线题，仅单个选项的做题动作处理
        /// - Parameters:
        ///   - wordId:
        ///   - step:
        ///   - right:
        ///   - type:
        func connectionAnswerAction(wordId: Int, step: Int, right: Bool, type: YXExerciseType) {

            // 更新单个项的完成状态
//            updateWordStepStatus(wordId: wordId, step: step, right: right, finish: false)
//
//            // 更新积分
//            updateWordScore(wordId: wordId, step: step, right: right, type: type)
//
//            // 更新对错
//            updateStepRightOrWrongStatus(wordId: wordId, step: step, right: right)
//
//            // 更新进度状态
//            progressManager.updateProgress(newWordArray: newWordArray, reviewWordArray: reviewWordArray)
        }

}
