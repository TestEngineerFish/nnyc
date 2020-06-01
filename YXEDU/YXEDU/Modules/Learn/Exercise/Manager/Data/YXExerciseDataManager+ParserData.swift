//
//  YXExerciseDataManager+ProcessData.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/3.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
// 数据清洗，得到我们需要的数据结构
extension YXExerciseDataManager {
    
    
    /// 处理从网络请求的数据
    /// - Parameter result: 网络数据
    func processExerciseData(result: YXExerciseResultModel?) {
        if (result?.newWordIds?.count ?? 0 == 0 && result?.steps?.count ?? 0 == 0) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(dataType)")
            dataStatus = .empty
        }

        // 为base时进入就带过来了
        if progressManager.dataType != .base {
            self.bookId = result?.bookId
            self.unitId = result?.unitId
            
            progressManager.bookId = self.bookId
            progressManager.unitId = self.unitId
        }
        
        self.ruleType = result?.ruleType ?? .p0
        YXGrowingManager.share.uploadExerciseType(self.ruleType.rawValue)
        YXLog("==== 当前学习规则: 【", self.ruleType.rawValue, "】 ====")

        // 处理新学
        self.processNewWord(result: result)

        // 处理复习
        self.processReviewWord(result: result)

        // 赋值选项处理器，便于后面题目处理练习答案选项
        self.optionManager.initData(newArray: newWordArray, reviewArray: self.reviewWords())

        // 初始化进度状态
        self.progressManager.initProgressStatus(newWordIds: result?.newWordIds, reviewWordIds: result?.reviewWordIds, type: self.ruleType)
        // 保存数据
        self.progressManager.updateProgress(newWordArray: newWordArray, reviewWordArray: reviewWordArray)
    }
    
    private func parserStepArray(result: YXExerciseResultModel?) {
        self.processNewWord(result: result)
        self.processReviewWord(result: result)
        guard let stepArray = result?.steps else {
            return
        }
        var reviewWordIndex = 0
        var currentGroup    = 0
        var newWordIndex    = 0
        /// 一组新学单词的数量
        let newWordBatchCount = self.isNewWordInBatch() ? self.newWordBatchSizeConfig() : self.newWordArray.count
        /// 一组复习单词的数量
        let reviewBatchCount = self.isNewWordInBatch() ? self.reviewWordBatchSizeConfig() : self.reviewWordArray.count
        var _newArray    = [YXWordExerciseModel]()
        // 添加新学
        while newWordIndex < self.newWordArray.count {
            let model = self.newWordArray[newWordIndex]
            _newArray.append(model)
            newWordIndex += 1
            // 满一组
            if newWordIndex - currentGroup * newWordBatchCount >= newWordBatchCount {
                // 总数组中已有可存放的位置
                if self.stepArray.count > currentGroup {
                    self.stepArray[currentGroup]["new"] = _newArray
                } else {
                    self.stepArray.append(["new" : _newArray])
                }
                // 更新
                _newArray     = []
                currentGroup += 1
            }
        }
        // 添加练习、复习
        currentGroup = 0
        var step1 = [[YXWordExerciseModel]]()
        var step2 = [[YXWordExerciseModel]]()
        var step3 = [[YXWordExerciseModel]]()
        var step4 = [[YXWordExerciseModel]]()
        self.reviewWordArray.forEach { (stepsModel) in
            stepsModel.exerciseSteps.forEach { (modelArray) in
                switch modelArray.first?.step {
                case .some(1):
                    step1.append(modelArray)
                case .some(2):
                    step2.append(modelArray)
                case .some(3):
                    step3.append(modelArray)
                case .some(4):
                    step4.append(modelArray)
                default:
                    break
                }
            }
        }
        step1.forEach { (wordModel) in
            if self.stepArray.count > currentGroup {
                let _newWordArray = self.stepArray[currentGroup]["new"] ?? []
            }
        }
        // 添加Step1的训练
        var _step1NewWordArray = [YXWordExerciseModel]()
        while !step1.isEmpty {
            // 获取当前组的新学单词列表
            if self.stepArray.count > currentGroup {
                _step1NewWordArray = self.stepArray[currentGroup]["new"] as? [YXWordExerciseModel] ?? []
            } else {
                self.stepArray.append(["step1":[]])
            }
            let modelArray = step1.first
            // 当前单词是否在当前新学组中
            let isContain  = _step1NewWordArray.contains { (model) -> Bool in
                model.word?.wordId == modelArray?.first?.word?.wordId
            }
            if isContain {
                if self.stepArray[currentGroup]["step1"]?.isEmpty ?? true {
                    self.stepArray[currentGroup]["step1"] = []
                }
                self.stepArray[currentGroup]["step1"]?.append(modelArray!)
            }
        }
        
//        self.stepArray.append(groupDict)
    }

    
    
    /// 处理新学跟读
    /// - Parameter result:
    func processNewWord(result: YXExerciseResultModel?) {
        self.exerciseWordIdArray = result?.newWordIds ?? []
        progressManager.initNewWordExerciseIds(exerciseIds: exerciseWordIdArray)
        
        // 处理新学单词
        for wordId in result?.newWordIds ?? [] {
            let bookId = result?.bookId ?? 0
            if let word = dao.selectWord(bookId: bookId, wordId: wordId) {
                var exercise = YXWordExerciseModel()
                exercise.question = createQuestionModel(word: word)
                exercise.word = word
                exercise.isNewWord = true
                exercise.isListenAndRepeat = true
                
                if (word.gradeId ?? 0) <= 6 {// 小学
                    exercise.type = .newLearnPrimarySchool
                    if word.partOfSpeechAndMeanings?.first?.isPhrase ?? false {
                        exercise.type = .newLearnPrimarySchool_Group
                    }
                } else { // 初中及其他
                    exercise.type = .newLearnJuniorHighSchool
                }
                
                newWordArray.append(exercise)
            }
        }
    }
    
    
    /// 处理复习单词
    /// - Parameter result:
    func processReviewWord(result: YXExerciseResultModel?) {
        // 设置为最大的数据，防止有时候前面1、2、3 步没有时，娶不到第四步的数据
        currentTurnIndex = 4
        
        for step in result?.steps ?? [] {
            for subStep in step {
                var exercise = subStep
                
                if exercise.step < currentTurnIndex + 1 {
                    currentTurnIndex = exercise.step - 1
                }
                                                                
                if exercise.type == .connectionWordAndImage || exercise.type == .connectionWordAndChinese {
                    for option in exercise.option?.firstItems ?? [] {
                        exercise.word = selectWord(wordId: option.optionId)
                        exercise.isNewWord = isNewWordStatus(wordId: option.optionId, exerciseArray: step)
                        self.addWordStep(exerciseModel: exercise, isBackup: false)
                    }
                } else {
                    if let e = selectWord(wordId: subStep.question?.wordId ?? 0) {
                        exercise.word = e
                        self.addWordStep(exerciseModel: exercise, isBackup: subStep.isBackup)
                    } else {
                        YXLog("单词不存在 id：",subStep.question?.wordId ?? 0)
                    }
                }
            }
        }

        // 获得所有需要复习的单词ID？？？，这个在接口里不是就给到了吗？
        let ids = result?.newWordIds ?? []
        for e in reviewWordArray {
            if ids.contains(e.wordId) {
//                exerciseWordIdArray.append(e.wordId)
            } else {
                reviewWordIdArray.append(e.wordId)
            }
        }
    
        
    }
    
    func addWordStep(exerciseModel: YXWordExerciseModel, isBackup: Bool) {
        
        let step = exerciseModel.step
        
        var index = -1
        for (i, e) in reviewWordArray.enumerated() {
            if e.wordId == exerciseModel.word?.wordId {
                index = i
                break
            }
        }
        
        if index == -1 {// 单词不存在
            var stepsModel = YXWordStepsModel()
            stepsModel.wordId = exerciseModel.word?.wordId ?? 0
            
            if isBackup {
                stepsModel.backupExerciseStep[String(step)] = exerciseModel
            } else {
                // 1.这里的数据结构可以调整
                // 2.这里是新创建的对象，这个数组肯定是空呀，为什么需要step-1呢？？
                stepsModel.exerciseSteps[step - 1].append(exerciseModel)
            }
            
            reviewWordArray.append(stepsModel)
        } else {// 单词存在
            if isBackup {
                reviewWordArray[index].backupExerciseStep[String(step)] = exerciseModel
            } else {
                reviewWordArray[index].exerciseSteps[step - 1].append(exerciseModel)
            }
        }
        
    }
    
    
    func createQuestionModel(word: YXBaseWordModel?) -> YXExerciseQuestionModel? {
        guard let w = word else { return nil }
        var question = YXExerciseQuestionModel()
        question.wordId = w.wordId
        question.word   = w.word
//        question.column = word.column
//        question.row = word.row
        return question
    }

    
    func reviewWords() -> [YXWordExerciseModel] {
        var array: [YXWordExerciseModel] = []
        for word in reviewWordArray {
            if let e = word.exerciseSteps.first?.first {
                array.append(e)
            }
        }
        return array
    }
    
    func isNewWordStatus(wordId: Int, exerciseArray: [YXWordExerciseModel]) -> Bool {
        for exercise in exerciseArray {
            if wordId == exercise.question?.wordId {
                return exercise.isNewWord
            }
        }
        return false
    }
    
    func selectWord(wordId: Int) -> YXWordModel? {
        if dataType == .base {
            return dao.selectWord(bookId: bookId ?? 0, wordId: wordId)
        } else {
            return dao.selectWord(wordId: wordId)
        }
    }
}
