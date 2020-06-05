//
//  YXExerciseServiceImpl+Data.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

/// 处理网络数据，存储到数据库
extension YXExerciseServiceImpl {
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchExerciseResultModels(planId: Int? = nil, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let request = YXExerciseRequest.exercise(type: learnConfig.learnType.rawValue, planId: learnConfig.planId)
        YYNetworkService.default.request(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            self._resultModel = response.data
            self.processData()
            completion?(true, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, error.message)
        }
    }
    
    /// 处理从网络请求的数据
    /// - Parameter result: 网络数据
    func processData() {
        if (_resultModel?.newWordIds?.count == .some(0) && _resultModel?.groups.count == .some(0)) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(learnConfig.learnType)")
            exerciseProgress = .none
            return
        }
        
        self.ruleType = _resultModel?.ruleType ?? .p0
        self.learnConfig.bookId = _resultModel?.bookId ?? 0
        self.learnConfig.unitId = _resultModel?.unitId ?? 0
        
        // 插入学习记录
        self.processStudyRecord()
        
        // 插入练习数据【新学/复习】
        self.processExercise(wordIds: _resultModel?.newWordIds ?? [], isNew: true)
        self.processExercise(wordIds: _resultModel?.reviewWordIds ?? [], isNew: false)
        
        // 插入单词步骤数据【新学/训练+复习】
        self.processWordStep()
    }
    
    
    func processStudyRecord() {
        self.studyDao.insertStudyRecord(learn: learnConfig, type: ruleType)
    }
    
    
    /// 练习数据
    /// - Parameter result: 网络数据
    func processExercise(wordIds: [Int], isNew: Bool) {
        YXLog("\n插入数据 is_new= \(isNew ) ====== 开始")
        let studyRecordId = self.studyDao.getStudyID(learn: learnConfig)
        // 处理单词列表
        for wordId in wordIds {
            var word = YXWordModel()
            word.wordId = wordId
            word.bookId = learnConfig.bookId
            word.unitId = learnConfig.unitId

            var exercise = YXExerciseModel()
            exercise.learnType = learnConfig.learnType
            exercise.word      = word
            exercise.isNewWord = isNew

            // 插入练习数据
            let exerciseId = exerciseDao.insertExercise(learn: learnConfig, rule: ruleType, study: studyRecordId, exerciseModel: exercise)

            // 映射单词ID和表ID
            self.wordIdMap[wordId] = exerciseId

            YXLog("插入练习数据——\(isNew) ", word.wordId ?? 0," \(exercise.group)", exerciseId > 0 ? "成功" : "失败")
        }
    }
    
    
    /// 处理训练和复习步骤
    /// - Parameter result:
    func processWordStep() {
        YXLog("\n插入步骤数据====== 开始")
        guard let groups = _resultModel?.groups else {
            return
        }
        let studyRecordId = self.studyDao.getStudyID(learn: learnConfig)
        for (index, group) in groups.enumerated() {
            for step in group {
                for subStep in step {
                    if isConnectionType(model: subStep) {
                        var exercise = subStep
                        for item in subStep.option?.firstItems ?? [] {
                            // 连线题，wordId没有，需要构造一个
                            exercise.wordId = item.optionId
                            addWordStep(subStep: exercise, study: studyRecordId, group: index)
                        }
                    } else {
                        addWordStep(subStep: subStep, study: studyRecordId, group: index)
                    }
                }
            }
        }
        
        YXLog("\n插入步骤数据====== 结束")
    }
    
    
    
    func addWordStep(subStep: YXExerciseModel, study recordId: Int, group: Int) {
        if let word = learnConfig.learnType == .base ?
            wordDao.selectWord(bookId: learnConfig.bookId ?? 0, wordId: subStep.wordId) :
            wordDao.selectWord(wordId: subStep.wordId) {

            var exercise = subStep
            exercise.learnType = self.learnConfig.learnType
            exercise.word = word
            exercise.group = group
            exercise.eid = wordIdMap[exercise.wordId] ?? 0

            let result = stepDao.insertWordStep(type: ruleType, study: recordId, exerciseModel: exercise)
            YXLog("插入\(stepString(exercise))步骤数据", word.wordId ?? 0, ":", word.word ?? "", " ", result ? "成功" : "失败")
        } else {
            YXLog("插入步骤数据, 不存在, id:",subStep.wordId)
        }
    }
    
    
    func createQuestionModel(word: YXBaseWordModel?) -> YXExerciseQuestionModel? {
        guard let w = word else { return nil }
        var question = YXExerciseQuestionModel()
        question.wordId = w.wordId
        question.word   = w.word
        return question
    }
    
    
    func isConnectionType(model: YXExerciseModel) -> Bool {
        return model.type == .connectionWordAndChinese || model.type == .connectionWordAndImage
    }

    
    func stepScoreRule() -> Int {
        return 0
    }
    
    
    func stepString(_ exercise: YXExerciseModel) -> String {
        if exercise.step == 0 {
            return "新学 step\(exercise.step)"
        } else if exercise.isNewWord {
            return "训练 step\(exercise.step)"
        } else {
            return "复习  step\(exercise.step)"
        }
    }
}

