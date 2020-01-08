//
//  YXExerciseDataManager+FetchData.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/3.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
    
    /// 出题逻辑（根据step，上轮对错）
    func buildExercise() -> YXWordExerciseModel? {
        // 筛选数据
        self.filterExercise()
        
        // 查找类型
        return findType()
    }
    
    
    /// 筛选数据
    func filterExercise() {
        // 当前轮次的完成数
        var finishCount = 0
        for e in currentTurnArray {
            if e.isCurrentTurnFinish {
                finishCount += 1
            }
        }
        
                
        if finishCount == currentTurnArray.count {
            currentTurnIndex += 1
            
            self.previousTurnArray = self.currentTurnArray
            self.currentTurnArray.removeAll()
            
            for (i, word) in reviewWordArray.enumerated() {
                for (j, step) in word.exerciseSteps.enumerated() {
                    if var exericse = fetchExerciseOfStep(exerciseArray: step) {
                        // 放到当前轮中的数据，清空掉这个对错的值，用于连线题在当前轮中，单个选项连接连错后提示
                        exericse.isRight = nil
                        
                        if exericse.isFinish {// 做过
                            if exericse.isContinue == true {// 如果上一轮有做错，需要继续做
                                for z in 0..<step.count {
                                    reviewWordArray[i].exerciseSteps[j][z].isContinue = nil
                                    reviewWordArray[i].exerciseSteps[j][z].isFinish = false
                                }
                                currentTurnArray.append(exericse)
                                break
                            }
                        } else {// 没做
                            if exericse.isNewWord {// 如果是新学，1到4步都要做
                                currentTurnArray.append(exericse)
                                break
                            } else if currentTurnIndex >= exericse.step {// 复习，到指定轮次和 step 相同是才开始训练
                                currentTurnArray.append(exericse)
                                break
                            }
                        }

                    }
                }
            }
                        
            // 排序
            self.sortCurrentTurn()
        }
    }
    
    func sortCurrentTurn() {
        
        // 按step 从高到低排序
        currentTurnArray.sort { (model1, model2) -> Bool in
            return model1.step > model2.step
        }

        
//        if currentTurn == 1 {
//            return
//        }
        return
        
        // 第二次排序，同一个step 上一轮没做错的排到前面
        var tmpStepArray: [[YXWordExerciseModel]] = []
                
        /// 数组的下标
        let arrayIndex: ((_ step: Int) -> Int) = { (stepIndex) in
            for (i, step) in tmpStepArray.enumerated() {
                if step.first?.step == stepIndex {
                    return i
                }
            }
            return -1
        }
        
        for e in currentTurnArray {
            let stepIndex = arrayIndex(e.step)
            if stepIndex == -1 {
                tmpStepArray.append([e])
            } else {
                tmpStepArray[stepIndex].append(e)
            }
        }
        
        
        /// 上轮是否做对
        let isPreviousRight: ((_ wordId: Int) -> Bool) = { [weak self] (wordId) in
            guard let self = self else { return true }
            
            var wrong = false
            for word in self.reviewWordArray {
                if word.wordId == wordId {
                    
                    for step in word.exerciseSteps {
                        let e = step.first
                        if (e?.isFinish == true) {
                            wrong = e?.isContinue ?? false
                        }
                    }
                    
                }
                
            }
            return !wrong
        }

        
        currentTurnArray.removeAll()
        
        for step in tmpStepArray {
            
            var rightArray: [YXWordExerciseModel] = []
            var wrongArray: [YXWordExerciseModel] = []
            
            for model in step {
                if isPreviousRight(model.word?.wordId ?? 0) {
                    rightArray.append(model)
                } else {
                    wrongArray.append(model)
                }
            }
            currentTurnArray.append(contentsOf: rightArray)
            currentTurnArray.append(contentsOf: wrongArray)
        }
        
        
    }
    
    
    /// 查找题型
    func findType() -> YXWordExerciseModel? {
        
        /// 连线题型
        if let ct = findConnectionType() {
            var connectionArray: [YXWordExerciseModel] = []
            for exercise in currentTurnArray {
                if exercise.step == ct.0 && exercise.type == ct.1 && exercise.isCurrentTurnFinish == false {
                    connectionArray.append(exercise)
                    if connectionArray.count >= 4 {
                        break
                    }
                }
            }
            
            if connectionArray.count > 1 {
                return YXExerciseOptionManager().connectionExercise(exerciseArray: connectionArray)
            } else {// 连线题，只有一个，就出备选题
                let e = connectionArray.first
                if let backupE = backupExercise(wordId: e?.word?.wordId ?? 0, step: e?.step ?? 0) {
                    return optionManager.processReviewWordOption(exercise: backupE)
                } else {
                    print("备选题为空， 出错")
                    return nil
                }
            }
        }
        
        /// 正常题型
        for e in currentTurnArray {
            if !e.isCurrentTurnFinish {
                return optionManager.processReviewWordOption(exercise: e)
            }
        }
        return nil
    }

    
    /// 查找当前轮中，没有开始做的连线题type和step，如果没有就返回空
    func findConnectionType() -> (Int, YXExerciseType)? {
        
        var step: Int?
        var type: YXExerciseType?
        
        for (i, e) in currentTurnArray.enumerated() {
            if e.isCurrentTurnFinish {
                continue
            }
                        
            if e.type == .connectionWordAndChinese || e.type == .connectionWordAndImage {
                
                if i == 0 {
                    step = e.step
                    type = e.type
                    break
                } else {
                    // 看前面的都完成了没有
                    if currentTurnArray[i - 1].isCurrentTurnFinish {
                        step = e.step
                        type = e.type
                        break
                    } else {
                        return nil
                    }
                }
                
            }
        }
        
        if let s = step, let t = type {
            return (s, t)
        }
        return nil
    }
    
   
    /// 获取练习题的备份题
    /// - Parameters:
    ///   - wordId: 单词Id
    ///   - step: 步骤
    func backupExercise(wordId: Int, step: Int) -> YXWordExerciseModel? {
        for word in reviewWordArray {
            if word.wordId == wordId {
                return word.backupExerciseStep[String(step)]
            }
        }
        return nil
    }
   
    /// 获取单词下某个step 具体的练习数据，可能需要根据得分来获取
    /// - Parameter exerciseArray:
    func fetchExerciseOfStep(exerciseArray: [YXWordExerciseModel]) -> YXWordExerciseModel? {
        var model: YXWordExerciseModel?
        if exerciseArray.count > 1 { // 根据得分取
            for exercise in exerciseArray {
                if exercise.isCareScore && exercise.score == fetchWordScore(wordId: exercise.word?.wordId ?? 0) {
                    model = exercise
                }
            }
        } else if let exercise = exerciseArray.first {
            model = exercise
        }
        return model
    }

    

    /// 查询单词练习得分
    /// - Parameter wordId: id
    func fetchWordScore(wordId: Int) -> Int {
       return 7
    }
    
}
