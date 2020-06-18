//
//  YXStudyRecordModel.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

struct YXStudyRecordModel {
    var studyId: Int      = 0
    var studyCount: Int   = 0
    var startTime: String = ""
    var studyDuration     = 0
    var learnConfg: YXLearnConfig    = YXBaseLearnConfig()
    var progress: YXExerciseProgress = .none
}


struct YXCurrentTurnModel {
    var studyId: Int = 0
    var stepId: Int = 0
    var step: Int = 0
    var turn: Int = 0
}
