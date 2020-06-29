//
//  YXExerciseServiceLmpl+Report.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension YXExerciseServiceImpl {
    /// 获取上报内容
    func getReportJson() -> String {
        var modelArray = [YXExerciseReportModel]()
        // 获得所有学习的单词单词
        let exerciseModelList = self.exerciseDao.getAllExerciseList(study: _studyId)
        exerciseModelList.forEach { (model) in
            guard let eid = model.exerciseId else {
                return
            }
            let data   = self.stepDao.getReportSteps(exercise: eid)
            var _model = model
            _model.errorCount = self.getExerciseWrongAmount(exercise: eid)
            _model.result     = data
            modelArray.append(_model)
        }
        return modelArray.toJSONString() ?? ""
    }

    /// 获取学习时长
    func getLearnDuration() -> Int {
        return self.studyDao.getDurationTime(learn: learnConfig)
    }

    func getNewWordCount() -> Int {
        return self.studyDao.getUnlearnedNewWordCount(study: _studyId)
    }

    func getReviewWordCount() -> Int {
        return self.studyDao.getUnlearnedReviewWordCount(study: _studyId)
    }

    func getExerciseWrongAmount(exercise id: Int) -> Int {
        let amount = self.stepDao.getExerciseWrongAmount(exercise: id)
        return amount
    }
}
