//
//  YXExerciseDataManager+ProcessData.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/3.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
    
    
    /// 处理从网络请求的数据
    /// - Parameter result: 网络数据
    func processExerciseData(result: YXExerciseResultModel?) {
        if (result?.newWordIds?.count ?? 0 == 0 && result?.steps?.count ?? 0 == 0) {
            dataStatus = .empty
        }
        
        // 为base时进入就带过来了
        if progressManager.dataType != .base {
            self.bookId = result?.bookId
            self.unitId = result?.unitId
            
            progressManager.bookId = self.bookId
            progressManager.unitId = self.unitId
        }
        
        self.processNewWord(result: result)
        self.processReviewWord(result: result)
        
        // 处理练习答案选项
        optionManager.initData(newArray: newExerciseArray, reviewArray: self.reviewWords())
                        
        // 处理进度状态

        progressManager.initProgressStatus(newWordIds: result?.newWordIds, reviewWordIds: result?.reviewWordIds)
        
        // 保存数据
        progressManager.updateProgress(newWordArray: newExerciseArray, reviewWordArray: reviewWordArray)
    }
    
    
    /// 处理新学跟读
    /// - Parameter result:
    func processNewWord(result: YXExerciseResultModel?) {
        // 处理新学单词
        for wordId in result?.newWordIds ?? [] {
            
            if let word = self.fetchWord(wordId: wordId) {
                var exercise = YXWordExerciseModel()
                exercise.question = createQuestionModel(word: word)
                exercise.word = word
                exercise.isNewWord = true
                
                if (word.gradeId ?? 0) <= 6 {// 小学
                    exercise.type = .newLearnPrimarySchool
                } else if (word.gradeId ?? 0) <= 9 { // 初中
                    exercise.type = .newLearnJuniorHighSchool
                }
                
                newExerciseArray.append(exercise)
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
                        exercise.word = fetchWord(wordId: option.optionId)
                        self.addWordStep(exerciseModel: exercise, isBackup: false)
                    }
                } else {
                    exercise.word = fetchWord(wordId: subStep.question?.wordId ?? 0)
                    
                    if (exercise.type != .fillWordGroup
                        && exercise.type != .fillWordAccordingToImage
                        && exercise.type != .fillWordAccordingToListen
                        && exercise.type != .fillWordAccordingToChinese
                        && exercise.type != .fillWordAccordingToChinese_Connection) {
                        exercise.question = createQuestionModel(word: exercise.word)
                    }
                    
                    self.addWordStep(exerciseModel: exercise, isBackup: subStep.isBackup)
                }
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
    
    
//    func createExerciseModel(step: YXExerciseStepModel) -> YXWordExerciseModel {
//        var exercise = YXWordExerciseModel()
//        exercise.type        = YXExerciseType(rawValue: step.type ?? "") ?? .none
//        exercise.question    = step.question
//        exercise.option      = step.option
//        exercise.answers     = step.answers
//        exercise.step        = step.step
//        exercise.isCareScore = step.isCareScore
//        exercise.isNewWord   = step.isNewWord
//
//        return exercise
//    }
    
    func reviewWords() -> [YXWordExerciseModel] {
        var array: [YXWordExerciseModel] = []
        for word in reviewWordArray {
            if let e = word.exerciseSteps.first?.first {
                array.append(e)
            }
        }
        return array
    }
}
