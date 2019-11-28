//
//  YXExerciseDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper


/// 练习的数据管理器
class YXExerciseDataManager: NSObject {
    
    
    public var newWordCount: Int = 0
    public var reviewWordCount: Int = 0
    public var bookId: Int = 0 // { return newExerciseModelArray.first?.word?.bookId ?? 0 }
    public var unitId: Int = 0 //{ return newExerciseModelArray.first?.word?.unitId ?? 0 }
        
    /// 剩余要复习的单词数量
    private var needReviewWordCount = 0
    private let dao: YXWordBookDao = YXWordBookDaoImpl()
    private var newExerciseModelArray: [YXWordExerciseModel] = []
//    private var reviewModelArray: [[YXWordExerciseModel]] = []
        
    private var currentTurnArray: [YXWordExerciseModel] = []
    /// 单词集合
    private var reviewWordArray: [YXWordStepsModel] = []
    
    private var backupExerciseModelArray: [String : YXWordExerciseModel] = [:]
    private let reviewWordIdsKey = "ReviewWordIdsKey"
    private var currentStep = 0
    
    
    /// 当前第几轮
//    private var currentTurn = 0
    /// 进度管理器
    private var progressManager: YXExcerciseProgressManager
    private var optionManager: YXExerciseOptionManager2
    
    
    init(bookId: Int, unitId: Int) {
        self.bookId = bookId
        self.unitId = unitId
        
        progressManager = YXExcerciseProgressManager()
        progressManager.bookId = bookId
        
        progressManager.unitId = unitId
        
        optionManager = YXExerciseOptionManager2()
        
        super.init()
    }
    
    //MARK: - public
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchTodayExerciseResultModels(completion: @escaping ((_ result: Bool, _ msg: String?) -> Void)) {
        let request = YXExerciseRequest.exercise
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            self.processExerciseData(result: response.data)
            completion(true, nil)
        }) { (error) in
            completion(false, error.message)
        }
    }
    
    
    /// 加载本地未学完的关卡数据
    func fetchUnCompletionExerciseModels() {
        let data = progressManager.localExerciseModels()
        newExerciseModelArray = data.0
//        reviewModelArray = data.1
    }

    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> (Int, Int, YXWordExerciseModel?) {
        let json = self.reportJson()
        print(json)
        var needNewWordCount = newExerciseModelArray.count
        
        if progressManager.isSkipNewWord() {
            needNewWordCount = 0
        } else {
            for exercise in self.newExerciseModelArray {
                if exercise.isFinish == false {
                    return (needNewWordCount, needReviewWordCount, exercise)
                }
                needNewWordCount -= 1
            }
        }
        
        
        return (needNewWordCount, needReviewWordCount, buildExercise())
    }
    
    /// 完成一个练习后，答题后修改状态
    /// - Parameters:
    ///   - exerciseModel: 练习数据
    ///   - right: 对错
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        
        if !right {
//            self.addWrongExercise(exerciseModel: exerciseModel)
            self.addWrongBook(exerciseModel: exerciseModel)
        }
        
        var finish = right
        // 选择题做错，也标注答题完成
        if right == false && (exerciseModel.type == .validationWordAndChinese || exerciseModel.type == .validationImageAndWord) {
            finish = true
        }
        if finish {
            
            
        }
        
        // 更新每个练习的完成状态
        updateFinishStatus(exerciseModel: exerciseModel, right: right)
        
        
        updateScore(exerciseModel: exerciseModel, right: right)
        updateStepRightOrWrongStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right)
        
        // 更新待学习数
        updateNeedReviewWordCount()
        
        // 处理进度状态
//        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewModelArray)
                
    }
    
    /// 上报关卡
    /// - Parameter test: 参数待定
    /// - Parameter completion: 上报后成功或失败的回调处理
    func reportUnit( completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let json = self.reportJson()
        let request = YXExerciseRequest.report(json: json)
        YYNetworkService.default.httpRequestTask(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
            completion?(response.dataArray != nil, nil)
        }) { (error) in
            completion?(false, error.message)
        }
    }
    

    func skipNewWord() {
        progressManager.setSkipNewWord()
    }
    
    func fetchWord(wordId: Int) -> YXWordModel? {
        return dao.selectWord(wordId: wordId)
    }
    
    //MARK: - private - process data
    
    private func processExerciseData(result: YXExerciseResultModel?) {
        self.processNewWord(result: result)
        self.processReviewWord(result: result)
        
        // 处理练习答案选项
        optionManager.initData(newArray: newExerciseModelArray, reviewArray: self.reviewWords())
        
        // 处理进度状态
//        progressManager.initProgressStatus(reviewWordIds: result?.reviewWordIds)
//        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewModelArray)
        
        YYCache.set(result?.reviewWordIds, forKey: reviewWordIdsKey)
    }
    
    
    /// 处理新学
    /// - Parameter result:
    private func processNewWord(result: YXExerciseResultModel?) {
        // 处理新学单词
        for wordId in result?.newWordIds ?? [] {
            
            if let word = self.fetchWord(wordId: wordId) {
                var exercise = YXWordExerciseModel()
                exercise.question = word
                exercise.word = word
                exercise.isNewWord = true
//                exercise.isFinish = true
                
                if (word.gradeId ?? 0) <= 6 {// 小学
                    exercise.type = .newLearnPrimarySchool
                } else if (word.gradeId ?? 0) <= 9 { // 初中
                    exercise.type = .newLearnJuniorHighSchool
                }
                
                newExerciseModelArray.append(exercise)
            }
        }
    }
    
    
    /// 处理复习单词
    /// - Parameter result:
    private func processReviewWord(result: YXExerciseResultModel?) {
        
        for step in result?.steps ?? [] {

            for subStep in step {
                var exercise = createExerciseModel(step: subStep)
                if exercise.type == .connectionWordAndImage || exercise.type == .connectionWordAndChinese {
                    for option in exercise.option?.firstItems ?? [] {
                        exercise.word = fetchWord(wordId: option.optionId)
                        self.addWordStep(exerciseModel: exercise, isBackup: false)
                    }
                } else {
                    exercise.word = fetchWord(wordId: subStep.wordId)
                    self.addWordStep(exerciseModel: exercise, isBackup: subStep.isBackup)
                }
            }

        }
    
    }
    
    private func addWordStep(exerciseModel: YXWordExerciseModel, isBackup: Bool) {
        
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
                stepsModel.backupExerciseStep[step] = exerciseModel
            } else {
                stepsModel.exerciseSteps[step - 1].append(exerciseModel)
            }
            
            reviewWordArray.append(stepsModel)
        } else {// 单词存在
            if isBackup {
                reviewWordArray[index].backupExerciseStep[step] = exerciseModel
            } else {
                reviewWordArray[index].exerciseSteps[step - 1].append(exerciseModel)
            }
        }
        
    }
    
    //MARK: - private - fetch data
    
    private func buildExercise() -> YXWordExerciseModel? {

       if currentTurnArray.count == 0 {
           
           for (i, word) in reviewWordArray.enumerated() {
               for (j, step) in word.exerciseSteps.enumerated() {
                   if let exericse = fetchExerciseOfStep(exerciseArray: step) {
                       if exericse.isFinish {
                           if exericse.isContinue == true {// 如果上一轮有做错过，需要继续做
                               for z in 0..<step.count {
                                   reviewWordArray[i].exerciseSteps[j][z].isContinue = nil
                               }
                               currentTurnArray.append(exericse)
                               break
                           }
                       } else {
                           currentTurnArray.append(exericse)
                           break
                       }

                   }
               }
           }
           currentTurnArray.sort { (model1, model2) -> Bool in
               return model1.step > model2.step
           }
       }
       
       if currentTurnArray.first?.type == .connectionWordAndChinese
           || currentTurnArray.first?.type == .connectionWordAndImage {
           
           var connectionArray: [YXWordExerciseModel] = []
           for exercise in currentTurnArray {
               if exercise.type == .connectionWordAndChinese || exercise.type == .connectionWordAndImage {
                   if connectionArray.count < 4 {
                       connectionArray.append(exercise)
                   }
               }
           }
           
           if connectionArray.count > 1 {
               return YXExerciseOptionManager2().connectionExercise(exerciseArray: connectionArray)
           } else {// 连线题，只有一个，就出备选题
               let e = connectionArray.first
               if let backupE = backupExercise(wordId: e?.word?.wordId ?? 0, step: e?.step ?? 0) {
                   return optionManager.processReviewWordOption(exercise: backupE)
               } else {
                   return nil
               }
           }
       }
   
       guard let e = currentTurnArray.first else {
           return nil
       }
       return optionManager.processReviewWordOption(exercise: e)
   }
   
   
   /// 获取练习题的备份题
   /// - Parameters:
   ///   - wordId: 单词Id
   ///   - step: 步骤
   private func backupExercise(wordId: Int, step: Int) -> YXWordExerciseModel? {
       for word in reviewWordArray {
           if word.wordId == wordId {
               return word.backupExerciseStep[step]
           }
       }
       return nil
   }
   
   
   /// 获取单词下某个step 具体的练习数据，可能需要根据得分来获取
   /// - Parameter exerciseArray:
   private func fetchExerciseOfStep(exerciseArray: [YXWordExerciseModel]) -> YXWordExerciseModel? {
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
   private func fetchWordScore(wordId: Int) -> Int {
       return 7
   }
    
    //MARK: - private - update data
    
    /// 更新某个练习的完成状态
    /// - Parameter exerciseModel: 哪个练习
    private func updateFinishStatus(exerciseModel: YXWordExerciseModel, right: Bool) {
        if exerciseModel.isNewWord {
            for (i, e) in newExerciseModelArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId {
                    newExerciseModelArray[i].isFinish = true
                    break
                }
            }
        } else {
            
            if exerciseModel.type == .connectionWordAndChinese || exerciseModel.type == .connectionWordAndImage {
                for item in exerciseModel.option?.firstItems ?? [] {
                    currentTurnArray.removeFirst()
                    self.updateWordStepStatus(wordId: item.optionId, step: exerciseModel.step, right: right)
                }
            } else {
                
                var finish = right
                // 选择题做错，也标注答题完成
                if right == false && (exerciseModel.type == .validationWordAndChinese || exerciseModel.type == .validationImageAndWord) {
                    finish = true
                }
                if finish {
                    currentTurnArray.removeFirst()
                }                
                
                self.updateWordStepStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right)
            }
            
        }
    }
    
    /// 更新得分
    /// - Parameters:
    ///   - exerciseModel:
    ///   - right:
    private func updateScore(exerciseModel: YXWordExerciseModel, right: Bool) {
        
        guard let wordId = exerciseModel.word?.wordId else {
            return
        }
        
        var score = 10
        
        if exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group {// 小学新学
            return
        } else if exerciseModel.type == .newLearnJuniorHighSchool {// 初中新学
            score = (right ? 7 : 0)
        } else {
            score = self.progressManager.fetchScore(wordId: wordId)
                                                            
            if exerciseModel.step == 1 {
                score -= (right ? 0 : 3)
            } else if exerciseModel.step == 2 {
                score -= (right ? 0 : 2)
            } else if exerciseModel.step == 3 {
                score -= (right ? 0 : 1)
            } else if exerciseModel.step == 4 {
                score -= (right ? 0 : 1)
            }
            
            score = score < 0 ? 0 : score
        }
        
        self.progressManager.updateScore(wordId: wordId, score: score)
        
    }
    
    
    /// 更新每个Step的 对错
    /// - Parameters:
    ///   - exerciseModel: 数据
    ///   - right: 对错
    private func updateStepRightOrWrongStatus(wordId: Int, step: Int, right: Bool) {
        
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
        
    }
    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    private func addWrongBook(exerciseModel: YXWordExerciseModel) {
        
    }
    

    
    
    
    
    
    /// 更新待学习数
    private func updateNeedReviewWordCount() {
        guard let wordIds = YYCache.object(forKey: reviewWordIdsKey) as? [Int] else {
            needReviewWordCount = 0
            return
        }
        
        var map: [Int : Bool] = [:]
        for wordId in wordIds {
            for word in reviewWordArray {
                for step in word.exerciseSteps {
                    let e = step.first
                    if wordId == word.wordId && e?.isFinish == false {
                        map[wordId] = false
                    }
                }
            }
        }
        
        needReviewWordCount = map.count
    }
    
    

    
    
    /// 更新每个练习的完成状态
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    ///   - right:
    private func updateWordStepStatus(wordId: Int, step: Int, right: Bool) {
        for (i, word) in reviewWordArray.enumerated() {
            if word.wordId == wordId {
                for (j, stepModel) in word.exerciseSteps.enumerated() {
                    
                    for (z, e) in stepModel.enumerated() {
                        if e.step == step {
                            reviewWordArray[i].exerciseSteps[j][z].isFinish = right
                            if right == false {
                                reviewWordArray[i].exerciseSteps[j][z].isContinue = true
                            }
                        }
                    }
                }
                break
            }
        }
    }
    
    
    
    
    
    

    
    private func createExerciseModel(step: YXExerciseStepModel) -> YXWordExerciseModel {
        var exercise = YXWordExerciseModel()
        exercise.type        = YXExerciseType(rawValue: step.type ?? "") ?? .none
        exercise.question    = step.question
        exercise.option      = step.option
        exercise.answers     = step.answers
        exercise.step        = step.step
        exercise.isCareScore = step.isCareScore

        return exercise
    }
    
    
    
    private func reportJson() -> String {
        var map: [Int : YXExerciseReportModel] = [:]
        
        for word in reviewWordArray {
            
            if let _ = map[word.wordId] {
                continue
            } else {
                let e = word.exerciseSteps.first?.first
                
                var report = YXExerciseReportModel()
                report.wordId = word.wordId
                report.bookId = e?.word?.bookId ?? 0
                report.unitId = e?.word?.unitId ?? 0
                report.score  = progressManager.fetchScore(wordId: word.wordId)
                report.result = YXExerciseReportModel.ResultModel()
                
                map[word.wordId]  = report
            }
        }
        
        for word in reviewWordArray {
            
            for step in word.exerciseSteps {
                guard let e = step.first else {
                    continue
                }
                switch e.step {
                case 1:
                    map[word.wordId]?.result?.one = e.isRight
                case 2:
                    map[word.wordId]?.result?.two = e.isRight
                case 3:
                    map[word.wordId]?.result?.three = e.isRight
                case 4:
                    map[word.wordId]?.result?.four = e.isRight
                default:
                    print()
                }
                break
            }
            
        }

                
        
        newWordCount = self.newExerciseModelArray.count
        reviewWordCount = map.count
        
        return Array(map.values).toJSONString() ?? ""
    }
    
    
    
    private func reviewWords() -> [YXWordExerciseModel] {
        var array: [YXWordExerciseModel] = []
        for word in reviewWordArray {
            if let e = word.exerciseSteps.first?.first {
                array.append(e)
            }
        }
        return array
    }
}

