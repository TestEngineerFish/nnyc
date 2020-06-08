//
//  YXExerciseServiceImpl+Option.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


extension YXExerciseServiceImpl {
    
    /// 加载答题选项
    func _loadExerciseOption() {
        let newExerciseModelList    = self.exerciseDao.getExerciseList(learn: self.learnConfig, includeNewWord: true, includeReviewWord: false)
        let reviewExerciseModelList = self.exerciseDao.getExerciseList(learn: self.learnConfig, includeNewWord: false, includeReviewWord: true)
        self._exerciseOptionManange.initOption(newArray: newExerciseModelList, reviewArray: reviewExerciseModelList)
    }
    
    /// 处理题目的选项
    func _processExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        return _exerciseOptionManange.processReviewWordOption(exercise: exercise)
    }
    
    /// 连线题
    func _processConnectionExerciseOption(exercises: [YXExerciseModel]) -> YXExerciseModel {
        return _exerciseOptionManange.connectionExercise(exerciseArray: exercises)
    }


//    /// 判断题
//    func _judgmentExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
//        let _exercise = self._exerciseOptionManange.processReviewWordOption(exercise: exercise)
//        return _exercise
//    }
    
    
//    /// 选择题
//    func _chooseExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
//        let _exercise = self._exerciseOptionManange.processReviewWordOption(exercise: exercise)
//        return _exercise
//    }
    
}
