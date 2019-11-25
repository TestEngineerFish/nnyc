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
    private var reviewModelArray: [[YXWordExerciseModel]] = []
    private var backupExerciseModelArray: [String : YXWordExerciseModel] = [:]
    private let reviewWordIdsKey = "ReviewWordIdsKey"
    private var currentStep = 0
    /// 进度管理器
    private var progressManager: YXExcerciseProgressManager
    
    
    init(bookId: Int, unitId: Int) {
        self.bookId = bookId
        self.unitId = unitId
        
        progressManager = YXExcerciseProgressManager()
        progressManager.bookId = bookId
        progressManager.unitId = unitId
        
        super.init()
    }
    
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
        reviewModelArray = data.1
    }

    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> (Int, Int, YXWordExerciseModel?) {
        let json = self.reportJson()
        print(json)
        var needNewWordCount = newExerciseModelArray.count
        
        for exercise in self.newExerciseModelArray {
            if exercise.isFinish == false {
                return (needNewWordCount, needReviewWordCount, exercise)
            }
            needNewWordCount -= 1
        }
        
        for (i, subArray) in reviewModelArray.enumerated() {
            self.currentStep = i
            for exercise in subArray {
                if exercise.isFinish == false {
                    if exercise.isCareScore {//是否关注分数
                        return (needNewWordCount, needReviewWordCount, fetchCareScoreExercise(exerciseModel: exercise))
                    } else {
                        return (needNewWordCount, needReviewWordCount, exercise)
                    }
                }
            }
        }
        
        return (needNewWordCount, needReviewWordCount, nil)
    }
    
    
    
    /// 完成一个练习后，答题后修改状态
    /// - Parameters:
    ///   - exerciseModel: 练习数据
    ///   - right: 对错
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        
        if !right {
            self.addWrongExercise(exerciseModel: exerciseModel)
            self.addWrongBook(exerciseModel: exerciseModel)
        }
        
        var finish = right
        // 选择题做错，也标注答题完成
        if right == false && (exerciseModel.type == .validationWordAndChinese || exerciseModel.type == .validationImageAndWord) {
            finish = true
        }
        if finish {
            updateFinishStatus(exerciseModel: exerciseModel)
        }
        updateScore(exerciseModel: exerciseModel, right: right)
        updateStepRightOrWrong(exerciseModel: exerciseModel, right: right)
        
        // 更新待学习数
        updateNeedReviewWordCount()
        
        // 处理进度状态
        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewModelArray)
                
    }
    
    /// 错题数据处理，重做
    /// - Parameter wrongExercise: 练习Model
    private func addWrongExercise(exerciseModel: YXWordExerciseModel) {
        var nextStep = currentStep + 1
        if nextStep >= self.reviewModelArray.count {
            nextStep = currentStep
        }
        
        if reviewModelArray[nextStep].contains(where: { (model) -> Bool in
            return model.word?.wordId == exerciseModel.word?.wordId && model.step == exerciseModel.step
        }) == false {
            reviewModelArray[nextStep].append(exerciseModel)
        }
        
    }
    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    private func addWrongBook(exerciseModel: YXWordExerciseModel) {
        
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
        for (i, _) in newExerciseModelArray.enumerated() {
            newExerciseModelArray[i].isFinish = true
        }
        
        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewModelArray)
    }
    
    
    /// 更新某个练习的完成状态
    /// - Parameter exerciseModel: 哪个练习
    private func updateFinishStatus(exerciseModel: YXWordExerciseModel) {
        if exerciseModel.isNewWord {
            for (i, e) in newExerciseModelArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId {
                    newExerciseModelArray[i].isFinish = true
                    break
                }
            }
        } else {
            for (i, subArray) in reviewModelArray.enumerated() {
                if i > currentStep { // 做错后重做的需要保护
                    break
                }
                for (j, e) in subArray.enumerated() {
                    if e.step == exerciseModel.step && e.word?.wordId == exerciseModel.word?.wordId {
                        reviewModelArray[i][j].isFinish = true
                    }
                }
            }
            
        }
    }
    
    
    /// 更新待学习数
    private func updateNeedReviewWordCount() {
        guard let wordIds = YYCache.object(forKey: reviewWordIdsKey) as? [Int] else {
            needReviewWordCount = 0
            return
        }
        
        var map: [Int : Bool] = [:]
        for wordId in wordIds {
            for subArray in reviewModelArray {
                for e in subArray {
                    if wordId == e.word?.wordId && e.isFinish == false {
                        map[wordId] = false
                    }
                }
            }
        }
        
        needReviewWordCount = map.count
    }
    
    
    
    /// 更新每个Step的 对错
    /// - Parameters:
    ///   - exerciseModel: 数据
    ///   - right: 对错
    private func updateStepRightOrWrong(exerciseModel: YXWordExerciseModel, right: Bool) {
        for (i, subArray) in self.reviewModelArray.enumerated() {
            for (j, e) in subArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId && e.step == exerciseModel.step {
                    if let _ = e.isRight {
                        return
                    }
                    reviewModelArray[i][j].isRight = right
                }
            }
        }
    }
    
    
    /// 更新得分
    /// - Parameters:
    ///   - exerciseModel:
    ///   - right:
    private func updateScore(exerciseModel: YXWordExerciseModel, right: Bool) {
        var score = 10
        
        if exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group {// 小学新学
            return
        } else if exerciseModel.type == .newLearnJuniorHighSchool {// 初中新学
            score = (right ? 7 : 0)
        } else {
            for subArray in reviewModelArray {
                for e in subArray {
                    if exerciseModel.word?.wordId == e.word?.wordId {
                        score = e.score
                        break
                    }
                }
            }
            
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
        

        for (i,subArray) in reviewModelArray.enumerated() {
            for (j, e) in subArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId {
                    reviewModelArray[i][j].score = score
                }
            }
        }
        
    }
    
    
    //MARK: - private
    private func processExerciseData(result: YXExerciseResultModel?) {
        self.processNewWord(result: result)
        self.processReviewWord(result: result)
        
        // 处理练习答案选项
        reviewModelArray = YXExerciseOptionManager().processOptions(newArray: newExerciseModelArray, reviewArray: reviewModelArray)
        
        // 处理进度状态
        progressManager.initProgressStatus(reviewWordIds: result?.reviewWordIds)
        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewModelArray)
        
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
            var subArray: [YXWordExerciseModel] = []
            for subStep in step {
                var exercise = createExerciseModel(step: subStep)
                exercise.word = fetchWord(wordId: subStep.wordId)
                
                if subStep.isBackup {
                    let key = "\(subStep.wordId)-" + (subStep.type ?? "")
                    backupExerciseModelArray[key] = exercise
                } else {
                    subArray.append(exercise)
                }
            }
            reviewModelArray.append(subArray)
        }
    }

    
    public func fetchWord(wordId: Int) -> YXWordModel? {
        return dao.selectWord(wordId: wordId)        
    }
    

    /// 查询单词练习得分
    /// - Parameter wordId: id
    private func fetchWordScore(wordId: Int) -> Int {
        return 7
    }
    
    
    private func fetchCareScoreExercise(exerciseModel: YXWordExerciseModel) -> YXWordExerciseModel? {
        let score = self.fetchWordScore(wordId: exerciseModel.word?.wordId ?? 0)
        for subArray in reviewModelArray {
            for exercise in subArray {
                if exercise.word?.wordId == exerciseModel.word?.wordId
                    && exercise.step == exerciseModel.step
                    && exercise.score == score {
                    return exercise
                }
            }
        }
        
        return nil
    }
    
    private func createExerciseModel(step: YXWordStepModel) -> YXWordExerciseModel {
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
        for subArray in reviewModelArray {
            for e in subArray {
                if let _ = map[e.word?.wordId ?? 0] {
                    continue
                } else {
                    var report = YXExerciseReportModel()
                    report.wordId = e.word?.wordId ?? 0
                    report.bookId = e.word?.bookId ?? 0
                    report.unitId = e.word?.unitId ?? 0
                    report.score  = e.score
                    report.result = YXExerciseReportModel.ResultModel()
                    
                    map[e.word?.wordId ?? 0]  = report
                }
            }
        }
        
        for subArray in reviewModelArray {
            for e in subArray {
                let wordId = e.word?.wordId ?? 0
                switch e.step {
                case 1:
                    map[wordId]?.result?.one = e.isRight
                case 2:
                    map[wordId]?.result?.two = e.isRight
                case 3:
                    map[wordId]?.result?.three = e.isRight
                case 4:
                    map[wordId]?.result?.four = e.isRight
                default:
                    print()
                }
            }
        }
                
        
        newWordCount = self.newExerciseModelArray.count
        reviewWordCount = map.count
        
        return Array(map.values).toJSONString() ?? ""
    }
    
}

