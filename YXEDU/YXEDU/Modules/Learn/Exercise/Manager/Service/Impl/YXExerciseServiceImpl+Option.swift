//
//  YXExerciseServiceImpl+Option.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


extension YXExerciseServiceImpl {
    
    /// 处理题目的选项
    func _processExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        
        // 判断题
        let judgmentArray: [YXQuestionType] = [.validationImageAndWord, .validationWordAndChinese]

        // 选择题
        let chooseArray: [YXQuestionType] = [.lookWordChooseImage, .lookExampleChooseImage, .listenChooseImage, .lookWordChooseChinese, .lookExampleChooseChinese, .lookChineseChooseWord, .lookImageChooseWord, .listenChooseWord, .listenChooseChinese]
        
        if judgmentArray.contains(exercise.type) {
            return _judgmentExerciseOption(exercise: exercise)
        } else if chooseArray.contains(exercise.type) {
            return _chooseExerciseOption(exercise: exercise)
        } else {
            YXLog("其他题型不用生成选项")
            return exercise
        }
    }
    
    /// 连线题 
    func _processConnectionExerciseOption(exercises: [YXExerciseModel]) -> YXExerciseModel {
        return _exerciseOptionManange.connectionExercise(exerciseArray: exercises)
    }
    
    
    /// 判断题
    func _judgmentExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        let _exercise = self._exerciseOptionManange.processReviewWordOption(exercise: exercise)
        return _exercise
    }
    
    
    /// 选择题
    func _chooseExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        let _exercise = self._exerciseOptionManange.processReviewWordOption(exercise: exercise)
        return _exercise
    }
    
}
