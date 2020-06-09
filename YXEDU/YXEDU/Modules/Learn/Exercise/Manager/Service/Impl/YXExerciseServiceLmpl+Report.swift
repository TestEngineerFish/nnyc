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
        let exerciseModelList = self.exerciseDao.getExerciseList(learn: self.learnConfig, includeNewWord: true, includeReviewWord: true)

        exerciseModelList.forEach { (model) in
            let data = self.stepDao.getReportSteps(with: model)
            var _model = YXExerciseReportModel()
            _model.wordId     = model.word?.wordId ?? 0
            _model.bookId     = model.word?.bookId
            _model.unitId     = model.word?.unitId
            _model.score      = model.score
            _model.errorCount = model.wrongCount
            _model.result     = ResultModel(JSON: data)
            modelArray.append(_model)
        }
        return modelArray.toJSONString() ?? ""
    }

    /// 获取学习时长
    func getLearnDuration() -> Int {
        return self.studyDao.getDurationTime(learn: learnConfig)
    }

    func getNewWordCount() -> Int {
        return self.exerciseDao.getNewWordCount()
    }

    func getReviewWordCount() -> Int {
        return self.exerciseDao.getReviewWordCount()
    }

    /// 更新学习时间
    func updateDurationTime() {
        let currentTime  = Date().local()
        let startTimeStr = self.studyDao.getStartTime(learn: learnConfig)
        let startTime    = NSDate(string: startTimeStr, format: NSDate.ymdHmsFormat())
        let duration     = currentTime.timeIntervalSince(startTime! as Date)
        self.studyDao.setDurationTime(learn: learnConfig, duration: Int(duration))
    }
}