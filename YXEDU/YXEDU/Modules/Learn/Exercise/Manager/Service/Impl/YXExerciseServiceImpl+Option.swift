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
    func processExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        
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
    
    /// 连线题 【已完成】
    func processConnectionExerciseOption(exercises: [YXExerciseModel]) -> YXExerciseModel {

        var exercise = exercises.first!
        var option = YXExerciseOptionModel()

        option.firstItems = []
        option.secondItems = []

        for e in exercises {
            var item = YXOptionItemModel()
            item.optionId = e.word?.wordId ?? 0
            item.content = e.word?.word
            option.firstItems?.append(item)


            var rightItem = YXOptionItemModel()
            rightItem.optionId = e.word?.wordId ?? 0

            if exercise.type == .connectionWordAndImage {
                rightItem.content = e.word?.imageUrl
            } else if exercise.type == .connectionWordAndChinese {
                rightItem.content = e.word?.meaning
            }


            option.secondItems?.append(rightItem)
        }

        option.secondItems = option.secondItems?.shuffled()

        exercise.option = option

        return exercise
    }
    
    
    /// 判断题 【待实现】
    func _judgmentExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        return nil
    }
    
    
    /// 选择题 【待实现】
    func _chooseExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        return nil
    }
    
}
