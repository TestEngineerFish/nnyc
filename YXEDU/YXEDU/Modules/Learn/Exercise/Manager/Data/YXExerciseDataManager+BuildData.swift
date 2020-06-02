//
//  YXExerciseDataManager+FetchData.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/3.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

extension YXExerciseDataManager {
    
    // 新学出题【跟读】
    func buildNewExercise() ->YXWordExerciseModel? {

        // 不跳过，才从新学取
        if self.isSkipNewWord() {
            return nil
        }

        for (index, exercise) in self.newWordArray.enumerated() {
            // 如果分批并且已经取得一组的数据，则返回nil
            if isNewWordInBatch() && index >= currentBatchIndex * newWordBatchSize {
                return nil
            }
            
            if !exercise.isFinish {
                var e = exercise
                let wid = e.word?.wordId ?? 0
                let bid = e.word?.bookId ?? 0
                e.word = dao.selectWord(bookId: bid, wordId: wid)
                return e
            }
        }
        return nil
    }

    /// 出题逻辑（根据step，上轮对错）
    func buildExercise() -> YXWordExerciseModel? {
        // 筛选数据
        self.filterExercise()
        
        // 查找类型
        return findType()
    }
    
    /// 筛选数据
    func filterExercise() {
        // 当前轮是否做完
        var isFinished = true
        for e in currentTurnArray {
            if !e.isCurrentTurnFinish {
                isFinished = false
            }
        }

        if isFinished {
            currentTurnIndex += 1
            // 清空当前轮已做完的数据
            self.currentTurnArray.removeAll()
            // 如果是主流程，则需要添加训练题
            if dataType == .base {
                filterExcercise()
            }
            filterReview()
            
            removeErrorStep()
            // 排序
            self.sortCurrentTurn()
        }
    }
    
    
    /// 主流程，筛选训练
    func filterExcercise() {
        var jumpStep = 0
        for (i, word) in reviewWordArray.enumerated() {
            // 
            if dataType == .base && exerciseWordIdArray.contains(word.wordId) == false {
                continue
            }
//            1.这个函数调用的上层已经限定了主流程，所以也没有必要这里在检测是否是主流程了
//            2.这个条件是上一个if的子集，所以上一个if条件没有必要了吧
            if dataType == .base && currentBatchNewWordIds().contains(word.wordId) == false {
                continue
            }
            
            // 只有基础学习时才分多批
            let newIndex  = transformIndex(stepModel: word)
            let batchSize = transformSize(stepModel: word)
            if dataType == .base && newIndex >= currentBatchIndex * batchSize {
                continue
            }
            
                            
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
                        } else if currentTurnArray.count == 0 { // 第1轮做对，进入第2轮，但其他的单词没有step1和step2，只有s3或者s4的情况
                            jumpStep = exericse.step // 保存跳跃的step下标
                            currentTurnArray.append(exericse)
                            break
                        } else if jumpStep == exericse.step {
                            currentTurnArray.append(exericse)
                            break
                        }
                    }

                }
            }
        }
    }
    
    /// 筛选复习
    func filterReview() {
        var jumpStep = 0
        for (i, word) in reviewWordArray.enumerated() {
            
            if dataType == .base && reviewWordIdArray.contains(word.wordId) == false {
                continue
            }
            
            // 只有基础学习时才分多批
            let newIndex = transformIndex(stepModel: word)
            let batchSize = transformSize(stepModel: word)
            if dataType == .base && newIndex >= currentBatchIndex * batchSize {
                continue
            }
                            
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
                        } else if currentTurnArray.count == 0 { // 第1轮做对，进入第2轮，但其他的单词没有step1和step2，只有s3或者s4的情况
                            jumpStep = exericse.step // 保存跳跃的step下标
                            currentTurnArray.append(exericse)
                            break
                        } else if jumpStep == exericse.step {
                            currentTurnArray.append(exericse)
                            break
                        }
                    }

                }
            }
        }
    }
    
    // 转换下标
    func transformIndex(stepModel: YXWordStepsModel) -> Int {
        var exercise: YXWordExerciseModel? = nil
        for step in stepModel.exerciseSteps {
            if step.count > 0 {
                exercise = step.first
                break
            }
        }
        
        if let e = exercise {
            if e.isNewWord {
                return exerciseWordIdArray.index(of: stepModel.wordId) ?? -1
            } else {
                return reviewWordIdArray.index(of: stepModel.wordId) ?? -1
            }
        }

        return -1
    }
    
    /// 转换大小
    func transformSize(stepModel: YXWordStepsModel) -> Int {
        var exercise: YXWordExerciseModel? = nil
        for step in stepModel.exerciseSteps {
            if step.count > 0 {
                exercise = step.first
                break
            }
        }
        
        if let e = exercise {
            if e.isNewWord {
                return newWordBatchSize
            } else {
                return reviewWordBatchSize
            }
        }

        return -1
    }
    
    
    /// 取数据的时候，会出现 step >  turnIndex的情况，因此需要把错加进来的删除掉
    func removeErrorStep() {
        // 是否有当前轮的
        var hasCurrentTurnStep = false
        for e in currentTurnArray {
            if e.step == currentTurnIndex  {
                hasCurrentTurnStep = true
                break
            }
        }
        
        var array: [YXWordExerciseModel] = []
        if hasCurrentTurnStep {
            for e in currentTurnArray {
                if e.step <= currentTurnIndex {
                    array.append(e)
                }
            }
            
            if array.count > 0 {
                currentTurnArray = array
            }
        }
        
    }
    
    func sortCurrentTurn() {
        
        // 按step 从高到低排序
        currentTurnArray.sort { (model1, model2) -> Bool in
            return model1.step > model2.step
        }

        if isChangeBatch {
            isChangeBatch = false
            
            var tmpExerciseArray: [YXWordExerciseModel] = []
            var tmpReviewArray: [YXWordExerciseModel] = []
            for exercise in currentTurnArray {
                if exercise.isNewWord {
                    tmpExerciseArray.append(exercise)
                } else {
                    tmpReviewArray.append(exercise)
                }
            }
            currentTurnArray = tmpExerciseArray + tmpReviewArray
        }
        
//        if currentTurn == 1 {
//            return
//        }
        return
//
//        // 第二次排序，同一个step 上一轮没做错的排到前面
//        var tmpStepArray: [[YXWordExerciseModel]] = []
//
//        /// 数组的下标
//        let arrayIndex: ((_ step: Int) -> Int) = { (stepIndex) in
//            for (i, step) in tmpStepArray.enumerated() {
//                if step.first?.step == stepIndex {
//                    return i
//                }
//            }
//            return -1
//        }
//
//        for e in currentTurnArray {
//            let stepIndex = arrayIndex(e.step)
//            if stepIndex == -1 {
//                tmpStepArray.append([e])
//            } else {
//                tmpStepArray[stepIndex].append(e)
//            }
//        }
//
//
//        /// 上轮是否做对
//        let isPreviousRight: ((_ wordId: Int) -> Bool) = { [weak self] (wordId) in
//            guard let self = self else { return true }
//
//            var wrong = false
//            for word in self.reviewWordArray {
//                if word.wordId == wordId {
//
//                    for step in word.exerciseSteps {
//                        let e = step.first
//                        if (e?.isFinish == true) {
//                            wrong = e?.isContinue ?? false
//                        }
//                    }
//
//                }
//
//            }
//            return !wrong
//        }
//
//
//        currentTurnArray.removeAll()
//
//        for step in tmpStepArray {
//
//            var rightArray: [YXWordExerciseModel] = []
//            var wrongArray: [YXWordExerciseModel] = []
//
//            for model in step {
//                if isPreviousRight(model.word?.wordId ?? 0) {
//                    rightArray.append(model)
//                } else {
//                    wrongArray.append(model)
//                }
//            }
//            currentTurnArray.append(contentsOf: rightArray)
//            currentTurnArray.append(contentsOf: wrongArray)
//        }
//
        
    }
    
    
    /// 查找题型
    func findType() -> YXWordExerciseModel? {
        // 连线题中，是否有单词拼写相同的，如果有都用备选题
        var sameWordIds: [Int] = []
        
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
            
            sameWordIds = sameWordIdArray(connectionArray: connectionArray)
            if sameWordIds.count == 0 {
                if connectionArray.count > 1 {
                    return YXExerciseOptionManager().connectionExercise(exerciseArray: connectionArray)
                } else {// 连线题，只有一个，就出备选题
                    let e = connectionArray.first
                    if let backupE = backupExercise(wordId: e?.word?.wordId ?? 0, step: e?.step ?? 0) {
                        return optionManager.processReviewWordOption(exercise: backupE)
                    } else {
                        YXLog("备选题为空， 出错")
                        return nil
                    }
                }
            }
        }
        
        /// 正常题型
        for e in currentTurnArray {
            if !e.isCurrentTurnFinish {
                if sameWordIds.count > 0 && (e.type == .connectionWordAndChinese || e.type == .connectionWordAndImage) {
                    if let backupE = backupExercise(wordId: e.word?.wordId ?? 0, step: e.step) {
                        return optionManager.processReviewWordOption(exercise: backupE)
                    } else {
                        YXLog("备选题为空， 出错")
                        return nil
                    }
                }
                return optionManager.processReviewWordOption(exercise: e)
            }
        }
        return nil
    }

    
    /// 查找当前轮中，没有开始做的连线题type和step，如果没有就返回空
    func findConnectionType() -> (Int, YXQuestionType)? {
        
        var step: Int?
        var type: YXQuestionType?
        
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
                if exercise.isCareScore && exercise.score == fetchQuestionTypeScore(wordId: exercise.word?.wordId ?? 0) {
                    model = exercise
                }
            }
        } else if let exercise = exerciseArray.first {
            model = exercise
        }
        return model
    }

    

    /// 查询题型得分【已掌握7分，不认识0分，和做题分数无关】
    /// - Parameter wordId: id
    func fetchQuestionTypeScore(wordId: Int) -> Int {
        return self.progressManager.fetchQuestionTypeScore(wordId: wordId)
    }
    
    
    func sameWordIdArray(connectionArray: [YXWordExerciseModel]) -> [Int] {
        var ids: [Int] = []
        for exercise in connectionArray {
            for e in connectionArray {
                if exercise.word?.wordId == e.word?.wordId {
                    continue
                }
                if exercise.word?.word == e.word?.word {
                    ids.append(exercise.word?.wordId ?? 0)
                }
            }
        }
        
        return ids
    }
    
}
