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
        let newWordModelList    = self.exerciseDao.getNewWordList(study: _studyId)
        let reviewWordModelList = self.exerciseDao.getReviewWordList(study: _studyId)
        self._exerciseOptionManange.initOption(newArray: newWordModelList, reviewArray: reviewWordModelList)
    }
    
    /// 处理题目的选项
    func _processExerciseOption(exercise: YXExerciseModel) -> YXExerciseModel? {
        return _exerciseOptionManange.processReviewWordOption(exercise: exercise)
    }
}
