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
        let _ = exerciseDao.deleteExpiredExercise()
        let _ = stepDao.deleteExpiredWordStep()
    }
    
    func updateProgress() {
        
    //        exerciseProgress = .reported
        
        if exerciseProgress == .learning {
            
        } else if exerciseProgress == .finished {
            
        } else {
            
        }
    }
}
