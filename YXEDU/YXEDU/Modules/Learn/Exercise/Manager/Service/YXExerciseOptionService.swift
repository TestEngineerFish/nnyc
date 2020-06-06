//
//  YXExerciseProcessService.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit


protocol YXExerciseOptionService {
    func initData(newArray: [YXExerciseModel], reviewArray: [YXExerciseModel])
    func processReviewWordOption(exercise: YXExerciseModel) -> YXExerciseModel?
    func connectionExercise(exerciseArray: [YXExerciseModel]) -> YXExerciseModel
}
