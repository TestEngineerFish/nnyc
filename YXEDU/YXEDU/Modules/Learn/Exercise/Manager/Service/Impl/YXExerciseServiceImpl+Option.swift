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
        let newExerciseModelList    = self.exerciseDao.getExerciseList(studyId: _studyId, includeNewWord: true, includeReviewWord: false)
        let reviewExerciseModelList = self.exerciseDao.getExerciseList(studyId: _studyId, includeNewWord: false, includeReviewWord: true)
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
}
