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
        let r1 = studyDao.deleteExpiredStudyRecord()
        let r2 = exerciseDao.deleteExpiredExercise()
        let r3 = stepDao.deleteExpiredWordStep()
        let r4 = turnDao.deleteExpiredTurn()
        
        YXLog("删除过期的学习记录", r1, r2, r3, r4)
    }
    
}

