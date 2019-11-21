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
    
    private let dao: YXWordBookDao = YXWordBookDaoImpl()
    
    private var newExerciseModelArray: [YXWordExerciseModel] = []
    private var reviewExerciseModelArray: [YXWordExerciseModel] = []
    private var backupExerciseModelArray: [String : YXWordExerciseModel] = [:]
        
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
        reviewExerciseModelArray = data.1
        
//        for (index, _) in self.reviewExerciseModelArray.enumerated() {
//            if (index == reviewExerciseModelArray.count - 1) {
//                reviewExerciseModelArray[index].isFinish = false
//            }
//        }
        
    }
    
    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> YXWordExerciseModel? {
        
        for exercise in self.newExerciseModelArray {
            if exercise.isFinish == false {
                return exercise
            }
        }
        
        for exercise in self.reviewExerciseModelArray {
            if exercise.isFinish == false {
                if exercise.isCareScore {//是否关注分数
                    return fetchCareScoreExercise(exerciseModel: exercise)
                } else {
                    return exercise
                }
            }
        }
        return nil
    }
    
    
    
    /// 完成一个练习后，答题后修改状态
    /// - Parameters:
    ///   - exerciseModel: 练习数据
    ///   - right: 对错
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        
        self.updateScore(exerciseModel: exerciseModel, right: right)
        
        var next = right
        
        if right == false && (exerciseModel.type == .validationWordAndChinese
        || exerciseModel.type == .validationImageAndWord) {
            next = true
        }
        
        if next {
            if exerciseModel.isNewWord {
                for (i, e) in newExerciseModelArray.enumerated() {
                    if e.word?.wordId == exerciseModel.word?.wordId {
                        newExerciseModelArray[i].isFinish = true
                        break
                    }
                }
            } else {
                for (i, e) in self.reviewExerciseModelArray.enumerated() {
                    if e.word?.wordId == exerciseModel.word?.wordId && e.step == exerciseModel.step {
                        reviewExerciseModelArray[i].isFinish = true
                        reviewExerciseModelArray[i].isRight = right
                    }
                    
                }
            }
        }
        
        // 处理进度状态
        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewExerciseModelArray)
        
        
        if !right {
            self.addWrongExercise(exerciseModel: exerciseModel)
            self.addWrongBook(exerciseModel: exerciseModel)
        }
    }
    
    /// 错题数据处理，重做
    /// - Parameter wrongExercise: 练习Model
    private func addWrongExercise(exerciseModel: YXWordExerciseModel) {
//        guard let model = exerciseModelArray.last else {
//            self.exerciseModelArray.append(exerciseModel)
//            return
//        }
//
//        if !(model.question?.wordId == exerciseModel.question?.wordId && model.type == exerciseModel.type) {
//            self.exerciseModelArray.append(exerciseModel)
//        }
        
    }
    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    private func addWrongBook(exerciseModel: YXWordExerciseModel) {
        
    }
    
    
//    private func updateScore(exerciseModel: YXWordExerciseModel, right: Bool) {
//        for (i, e) in self.reviewExerciseModelArray.enumerated() {
//            if e.word?.wordId == exerciseModel.word?.wordId && e.step == exerciseModel.step {
//                reviewExerciseModelArray[i].isFinish = true
//                reviewExerciseModelArray[i].isRight = right
//            }
//
//        }
//    }
    
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
    
    
    func updateScore(exerciseModel: YXWordExerciseModel, right: Bool) {
        var score = 10
        
        if exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group {// 小学新学
            return
        } else if exerciseModel.type == .newLearnJuniorHighSchool {// 初中新学
            score = (right ? 7 : 0)
        } else {
            for e in reviewExerciseModelArray {
                if exerciseModel.word?.wordId == e.word?.wordId {
                    score = e.score
                    break
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
        
                
        for (i, e) in self.reviewExerciseModelArray.enumerated() {
            if e.word?.wordId == exerciseModel.word?.wordId {
                reviewExerciseModelArray[i].score = score
            }
        }
    }
    
    
    //MARK: - private
    private func processExerciseData(result: YXExerciseResultModel?) {
        self.processNewWord(result: result)
        self.processReviewWord(result: result)
        
        // 处理练习答案选项
        reviewExerciseModelArray = YXExerciseOptionManager().processOptions(newArray: newExerciseModelArray, reviewArray: reviewExerciseModelArray)
        
        // 处理进度状态
        progressManager.initProgressStatus()
        progressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewExerciseModelArray)
    }
    
    
    /// 处理新学
    /// - Parameter result: <#result description#>
    private func processNewWord(result: YXExerciseResultModel?) {
        // 处理新学单词
        for wordId in result?.newWords ?? [] {
            
            if let word = self.fetchWord(wordId: wordId) {
                var exercise = YXWordExerciseModel()
                exercise.question = word
                exercise.word = word
                exercise.isNewWord = true
                
                if (word.gradeId ?? 0) <= 6 {// 小学
                    exercise.type = .newLearnPrimarySchool
                } else if (word.gradeId ?? 0) <= 9 { // 初中
                    exercise.type = .newLearnJuniorHighSchool
                }
                
                newExerciseModelArray.append(exercise)
            }
        }
    }
    
    private func processReviewWord(result: YXExerciseResultModel?) {
        // 处理复习单词
        for step in result?.steps ?? [] {
            
            for subStep in step {
                var exercise = createExerciseModel(step: subStep)
                exercise.word = fetchWord(wordId: subStep.wordId)
                
                if subStep.isBackup {
                    let key = "\(subStep.wordId)-" + (subStep.type ?? "")
                    backupExerciseModelArray[key] = exercise
                } else {
                    reviewExerciseModelArray.append(exercise)
                }
            }
            
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
        for exercise in self.reviewExerciseModelArray {
            if exercise.word?.wordId == exerciseModel.word?.wordId
                && exercise.step == exerciseModel.step
                && exercise.score == score {
                return exercise
            }
        }
        return nil
    }
    
    private func createExerciseModel(step: YXWordStepModel) -> YXWordExerciseModel {
        var exercise = YXWordExerciseModel()
        exercise.type = YXExerciseType(rawValue: step.type ?? "") ?? .none
        exercise.question = step.question
        exercise.option = step.option
        exercise.answers = step.answers
        exercise.step = step.step
        exercise.isCareScore = step.isCareScore

        return exercise
    }
    
    
    
    private func reportJson() -> String {
        var map: [Int : YXExerciseReportModel] = [:]
        for e in reviewExerciseModelArray {
            if let _ = map[e.word?.wordId ?? 0] {
                continue
            } else {
                var report = YXExerciseReportModel()
                report.wordId = e.word?.wordId ?? 0
                report.bookId = e.word?.bookId ?? 0
                report.unitId = e.word?.unitId ?? 0
                report.score = e.score
                report.result = YXExerciseReportModel.ResultModel()
                
                map[e.word?.wordId ?? 0]  = report
            }
        }
        
        for e in reviewExerciseModelArray {
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
        
        
        newWordCount = self.newExerciseModelArray.count
        reviewWordCount = map.count
        
        return Array(map.values).toJSONString() ?? ""
    }
    
}

