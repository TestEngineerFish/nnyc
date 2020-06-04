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
            self.processData(result: response.data)
            completion?(true, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, error.message)
        }
    }
    
    /// 处理从网络请求的数据
    /// - Parameter result: 网络数据
    func processData(result: YXExerciseResultModel?) {
        if (result?.newWordIds?.count ?? 0 == 0 && result?.steps?.count ?? 0 == 0) {
            YXLog("⚠️获取数据为空，无法生成题型，当前学习类型:\(learnConfig.learnType)")
            exerciseProgress = .none
            return
        }
        
        self.ruleType = result?.ruleType ?? .p0
        self.learnConfig.bookId = result?.bookId ?? 0
        self.learnConfig.unitId = result?.unitId ?? 0
        
        // 插入练习数据【新学/复习】
        self.processExercise(wordIds: result?.newWordIds ?? [], isNew: true)
        self.processExercise(wordIds: result?.reviewWordIds ?? [], isNew: false)
//        self.processExercise(wordIds: result?.reviewWordIds ?? [], type: .review)
        
        // 插入单词步骤数据【新学/训练+复习】
        self.processNewWordStep(wordIds: result?.newWordIds ?? [])
        self.processWordStep(result: result)
    }
    
    
    /**
     *
    type.rawValue,
    exerciseModel.dataType.rawValue,
    exerciseModel.word?.wordId as Any,
    exerciseModel.word?.word as Any,
    exerciseModel.word?.bookId as Any,
    exerciseModel.word?.unitId as Any,
    planId as Any,
    exerciseModel.isNewWord,
    exerciseModel.unfinishStepCount

     */
    /// 练习数据
    /// - Parameter result: 网络数据
    func processExercise(wordIds: [Int], isNew: Bool) {
        YXLog("\n插入数据 is_new= \(isNew ) ====== 开始")
        // 处理单词列表
        for (index, wordId) in wordIds.enumerated() {
            
            var word = YXWordModel()
            word.wordId = wordId
            word.bookId = learnConfig.bookId
            word.unitId = learnConfig.unitId
            
            var exercise = YXExerciseModel()
            exercise.learnType = learnConfig.learnType
            exercise.word = word
            exercise.isNewWord = isNew
            
            // 插入练习数据
            let exerciseId = exerciseDao.insertExercise(type: ruleType, planId: learnConfig.planId, exerciseModel: exercise)
            YXLog("插入练习数据——\(isNew) ", word.wordId ?? 0," \(exercise.group)", exerciseId > 0 ? "成功" : "失败")
            
        }
    }
    
    
    
    
    
    /// 处理新学跟读步骤
    /// - Parameter result:
    func processNewWordStep(wordIds: [Int]) {
        
        YXLog("\n插入新学步骤数据====== 开始")
        // 处理新学单词
        for wordId in wordIds {
            
            if let word = wordDao.selectWord(bookId: learnConfig.bookId, wordId: wordId) {
                
                var exercise = YXExerciseModel()
                exercise.question = createQuestionModel(word: word)
                exercise.learnType = learnConfig.learnType
                exercise.word = word
                exercise.wordType = .new
                
                if (word.gradeId ?? 0) <= 6 {// 小学
                    exercise.type = .newLearnPrimarySchool
                    if word.partOfSpeechAndMeanings?.first?.isPhrase ?? false {
                        exercise.type = .newLearnPrimarySchool_Group
                    }
                } else { // 初中及其他
                    exercise.type = .newLearnJuniorHighSchool
                }
                
                // 插入单词——新学步骤
                let result = stepDao.insertWordStep(type: ruleType, exerciseModel: exercise)
                YXLog("插入单词——新学步骤", word.wordId ?? 0, ":", word.word ?? "", " ", result ? "成功" : "失败")
            } else {
                YXLog("插入新学数据, 单词不存在:", wordId)
            }
        }
        YXLog("\n插入新学步骤数据====== 结束")
    }
    
    
    
    
    /// 处理训练和复习步骤
    /// - Parameter result:
    func processWordStep(result: YXExerciseResultModel?) {
        YXLog("\n插入训练+复习步骤数据====== 开始")
        for step in result?.steps ?? [] {
            for subStep in step {
                
                if let word = learnConfig.learnType == .base ?
                    wordDao.selectWord(bookId: learnConfig.bookId, wordId: subStep.question?.wordId ?? 0) :
                    wordDao.selectWord(wordId: subStep.question?.wordId ?? 0) {
                    
                    var exercise = subStep
                    exercise.learnType = self.learnConfig.learnType
                    exercise.wordType = exercise.isNewWord ? .exercise : .review
                    exercise.word = word
                    let result = stepDao.insertWordStep(type: ruleType, exerciseModel: exercise)
                    YXLog("插入\(exercise.wordType.desc)步骤数据", word.wordId ?? 0, ":", word.word ?? "", " ", result ? "成功" : "失败")
                } else {
                    YXLog("插入步骤数据, 不存在, id:",subStep.question?.wordId ?? 0)
                }
            }
        }
        YXLog("\n插入训练+复习步骤数据====== 结束")
    }
    
    
    
    func createQuestionModel(word: YXBaseWordModel?) -> YXExerciseQuestionModel? {
        guard let w = word else { return nil }
        var question = YXExerciseQuestionModel()
        question.wordId = w.wordId
        question.word   = w.word
        return question
    }
    
    
    /// 获取分组下标
    /// - Parameters:
    ///   - index:
    ///   - count:
    ///   - type: 单词类型
    private func groupIndex(index: Int, count: Int, type: YXExerciseWordType) -> Int {
        ruleType = .p4
        // 只有新学才有分组学习
        if self.learnConfig.learnType != .base {
            return 1
        }
        
        // 新学是否分组
        if type == .new && isGroup() == false {
            return 1
        }
                
        var batchSize = 0
        switch type {
            case .new:
                batchSize = self.newWordBatchSize
            case .exercise:
                batchSize = self.exerciseWordBatchSize
            default:
                batchSize = self.reviewWordBatchSize
        }

        return lround(Double(index + 1) / Double(batchSize) + 0.4)
    }
    
    
    // 新学是否分组学习
    func isGroup() -> Bool {
        return ruleType == .p4 || ruleType == .a1 || ruleType == .a2
    }
    
    
}

