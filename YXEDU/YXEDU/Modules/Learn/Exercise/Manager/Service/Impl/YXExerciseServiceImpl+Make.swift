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

}
