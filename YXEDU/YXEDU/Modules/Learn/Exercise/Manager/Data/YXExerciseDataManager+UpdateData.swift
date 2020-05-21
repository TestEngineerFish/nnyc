//
//  YXExerciseDataManager+UpdateData.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/3.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
    /// 更新正常题型练习的完成状态 （不包括连线题）
    /// - Parameter exerciseModel: 哪个练习
    func updateNormalExerciseFinishStatus(exerciseModel: YXWordExerciseModel, right: Bool) {
        if exerciseModel.isListenAndRepeat && (exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group || exerciseModel.type == .newLearnJuniorHighSchool) {
            
            for (i, e) in newWordArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId {
                    newWordArray[i].isFinish = true
                    break
                }
            }
            
        } else {
                        
            var finish = right
            // 选择题做错，也标注答题完成
            if right == false && (exerciseModel.type == .validationWordAndChinese || exerciseModel.type == .validationImageAndWord) {
                finish = true
            }
            if finish {
                updateCurrentTurnStatus(wordId: exerciseModel.word?.wordId ?? 0)
            }
            
            self.updateWordStepStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right, finish: finish)
            
        }
    }
    
    
    /// 连线题型 ，连线题所有项全部连完
    func updateConnectionExerciseFinishStatus(exerciseModel: YXWordExerciseModel, right: Bool) {
        // 进入这个分支，表示连线题，所有项都完成（不管中间是否有出错）
        for item in exerciseModel.option?.firstItems ?? [] {
            updateCurrentTurnStatus(wordId: item.optionId)
            self.updateWordStepStatus(wordId: item.optionId, step: exerciseModel.step, right: right, finish: right)
        }
        
    }
    
    
    /// 更新得分
    /// - Parameters:
    ///   - exerciseModel:
    ///   - right:
    public func updateWordScore(wordId: Int, step: Int, right: Bool, type: YXExerciseType) {
        
        var score = 10
        if type == .newLearnPrimarySchool || type == .newLearnPrimarySchool_Group || type == .newLearnJuniorHighSchool {// 小学新学 和 初中新学 不计算分数
            return
        } else {
            score = self.progressManager.fetchScore(wordId: wordId)
                                                            
            if step == 1 {
                score -= (right ? 0 : 3)
            } else if step == 2 {
                score -= (right ? 0 : 2)
            } else if step == 3 {
                score -= (right ? 0 : 1)
            } else if step == 4 {
                score -= (right ? 0 : 1)
            }
            
            score = score < 0 ? 0 : score
        }
        
        self.progressManager.updateScore(wordId: wordId, score: score)
        
        if !right { // 错误次数
            self.progressManager.updateErrorCount(wordId: wordId)
        }
        
    }
    
    
    /// 更新新学单词跟读得分
    /// - Parameters:
    public func updateNewWordReadScore(exerciseModel: YXWordExerciseModel) {
        // 只有新学题型才算听力分，否则其他题型的分数把听力发给覆盖了
        if exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group {
            if let wordId = exerciseModel.word?.wordId {
                let score = exerciseModel.listenScore
                self.progressManager.updateNewWordReadScore(wordId: wordId, score: score)
            }
        }

    }
    
    
    /// 更新题型得分
    /// - Parameter exerciseModel: <#exerciseModel description#>
    public func updateQuestionTypeScore(exerciseModel: YXWordExerciseModel) {
        // 只有初中新学，才更新题型分
        if exerciseModel.type == .newLearnJuniorHighSchool {
            if let wordId = exerciseModel.word?.wordId {
                let score = exerciseModel.questionTypeScore
                self.progressManager.updateQuestionTypeScore(wordId: wordId, score: score)
            }
        }

    }
    
    
    /// 更新每个Step的 对错
    /// - Parameters:
    ///   - exerciseModel: 数据
    ///   - right: 对错
    public func updateStepRightOrWrongStatus(wordId: Int, step: Int, right: Bool) {
        
        for (i, word) in reviewWordArray.enumerated() {
            if word.wordId == wordId {
                for (j, stepModel) in word.exerciseSteps.enumerated() {
                    for (z, e) in stepModel.enumerated() {
                        if e.step == step {
                            if e.isRight == nil {
                                reviewWordArray[i].exerciseSteps[j][z].isRight = right
                            }
                        }
                    }
                }
                break
            }
        }
        
        
        for (i, e) in currentTurnArray.enumerated() {
            if e.word?.wordId == wordId && e.step == step {
                if e.isRight == nil {
                    currentTurnArray[i].isRight = right
                    break
                }
            }
        }
        
    }
    
    
    /// 更新每个练习的完成状态 （是否需要重做）
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    ///   - right:
    func updateWordStepStatus(wordId: Int, step: Int, right: Bool, finish: Bool) {
        for (i, word) in reviewWordArray.enumerated() {
            if word.wordId == wordId {
                for (j, stepModel) in word.exerciseSteps.enumerated() {
                    
                    for (z, e) in stepModel.enumerated() {
                        if e.step == step {
                            reviewWordArray[i].exerciseSteps[j][z].isFinish = finish
                            if right == false {
                                // 如果做错，下一轮需要重做
                                reviewWordArray[i].exerciseSteps[j][z].isContinue = true
                            }
                        }
                    }
                }
                break
            }
        }
    }
    
    
    func updateCurrentTurnStatus(wordId: Int) {
        for (i, e) in self.currentTurnArray.enumerated() {
            if e.word?.wordId == wordId {
                currentTurnArray[i].isCurrentTurnFinish = true
                break
            }
        }
    }
    
    /// 更新待学习数 - 新学
    func updateNeedNewStudyCount() {
        let wordIds = progressManager.loadLocalWordsProgress().0
        
        if wordIds.count == 0 {
            needNewStudyCount = 0
            return
        }

        var map: [Int : Bool] = [:]
        for wordId in wordIds {
            for word in reviewWordArray {
                for step in word.exerciseSteps {
                    let e = step.first
                    if wordId == word.wordId && (e?.isFinish == false || e?.isContinue == true) {
                        map[wordId] = false
                    }
                }
            }
        }
        
        YXLog("更新：新学单词数\(map.count)")
        needNewStudyCount = map.count
    }
    
    /// 更新待学习数 - 复习
    func updateNeedReviewCount() {
        let wordIds = progressManager.loadLocalWordsProgress().1
        
        if wordIds.count == 0 {
            needReviewCount = 0
            return
        }

        var map: [Int : Bool] = [:]
        for wordId in wordIds {
            for word in reviewWordArray {
                for step in word.exerciseSteps {
                    let e = step.first
                    if wordId == word.wordId && (e?.isFinish == false || e?.isContinue == true) {
                        map[wordId] = false
                    }
                }
            }
        }
        YXLog("更新：复习单词数\(map.count)")
        YXLog("----------------- 听写数量：", map.count)
        needReviewCount = map.count
        
        if needReviewCount == 0 {
            
        }
        
        
    }
        
    
    func updateCurrentPatchIndex() {
        // 只有基础学习时才分多批
        if dataType != .base {
            return
        }
        YXLog("bb+++++++++++++当前 currentPatchIndex = ", currentBatchIndex)
        
        // 新学分批下标
        var newWordBatch = 0
        if isNewWordInBatch() {
            for (index, exercise) in self.newWordArray.enumerated() {
                if exercise.isFinish == false {
                    newWordBatch = lround(Double(index + 1) / Double(newWordBatchSize) + 0.4)
                    break
                }
            }
        }
        YXLog("bb+++++++++++++新学批次 currentPatchIndex = ", newWordBatch)
        
        
        // 训练批次下标
        var exerciseBatch = 0
        for (index, wordId) in exerciseWordIdArray.enumerated() {
            if isFinishWord(wordId: wordId) == false {
                exerciseBatch = lround(Double(index + 1) / Double(newWordBatchSize) + 0.4)
                break
            }
        }
        YXLog("bb+++++++++++++训练批次 currentPatchIndex = ", exerciseBatch)

        // 复习批次下标
        var reviewBatch = 0
        for (index, wordId) in reviewWordIdArray.enumerated() {
            if isFinishWord(wordId: wordId) == false {
                reviewBatch = lround(Double(index + 1) / Double(reviewWordBatchSize) + 0.4)
                break
            }
        }
        YXLog("bb+++++++++++++复习批次 currentPatchIndex = ", reviewBatch)
        
        var minBatch = 1
        if exerciseBatch == 0 {
            minBatch = reviewBatch
        }
        if reviewBatch == 0 {
            minBatch = exerciseBatch
        }
        if exerciseBatch != 0 && reviewBatch != 0 {
            minBatch = min(exerciseBatch, reviewBatch)
            
            if isNewWordInBatch() { // 如果新学要分批, 处理新学比训练和复习的数量不一致，造成的后续根据批次取数据问题
                // 如果新学比 训练和复习的多
                if newWordBatch > minBatch && isAllWordFinish() {
                    minBatch = newWordBatch
                }
            }
            
        }
                
        // 开始新的批次了
        if minBatch > currentBatchIndex {
            isChangeBatch = true
            currentBatchIndex = minBatch

            // 一批学完后，重置轮的下标
            if isResetTurnIndex {
                currentTurnIndex = 0
                YXLog("bb+++++++++++++重置 轮 下标")
            }
        }
                
        if currentBatchIndex == 0 {
            currentBatchIndex = 1
        }
        
        isResetTurnIndex = true
        
        YXLog("bb+++++++++++++ currentPatchIndex = ", currentBatchIndex)
        
    }
    
    func isFinishWord(wordId: Int) -> Bool {
        
        for word in reviewWordArray {
            if word.wordId == wordId {
                var stepCount = 0 // 有几个step
                var finishCount = 0 // 完成的step数
                
                for step in word.exerciseSteps {
                    if let exericse = fetchExerciseOfStep(exerciseArray: step) {
                        stepCount += 1
                        if exericse.isFinish && exericse.isContinue == nil {// 做过
                            finishCount += 1
                        }
                        
                    }
                }
                
                return stepCount == finishCount
            }
        }
        return false
    }

    
    /// 是否全部完成
    func isAllNewWordFinish() -> Bool {
        var finishCount = 0
        for exercise in self.newWordArray {
            if exercise.isFinish {
                finishCount += 1
            }
        }
        
        return finishCount == newWordArray.count
    }
    
    
    /// 训练和复习是否全部完成
    func isAllWordFinish() -> Bool {
        var finishCount = 0
        for e in reviewWordArray {
            if isFinishWord(wordId: e.wordId) {
                finishCount += 1
            }
        }
        
        return finishCount == reviewWordArray.count
    }
    
    
    
}