//
//  YXStudyRecordModel.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

struct YXStudyRecordModel {
    var studyId: Int = 0
    var learnConfg: YXLearnConfig = YXBaseLearnConfig()
    var ruleType: YXExerciseRule = .p0
    var currentGroup: Int = -1
    var currentTurn: Int = -1
}
