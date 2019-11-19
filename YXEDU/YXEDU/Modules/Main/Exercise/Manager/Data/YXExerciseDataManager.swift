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

    private let dao: YXWordBookDao = YXWordBookDaoImpl()
    
    private var newExerciseModelArray: [YXWordExerciseModel] = []
    private var reviewExerciseModelArray: [YXWordExerciseModel] = []
    private var backupExerciseModelArray: [String : YXWordExerciseModel] = [:]
    
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
        let data = YXExcerciseProgressManager.localExerciseModels()
        newExerciseModelArray = data.0
        reviewExerciseModelArray = data.1
    }
    
    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> YXWordExerciseModel? {
        print("\n====================\n")
        print(reportJson())
        
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
    ///   - next: 是否做下一题
    func completionExercise(exerciseModel: YXWordExerciseModel, right: Bool) {
        
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
            
            // 处理进度状态
            YXExcerciseProgressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewExerciseModelArray)
        }
        
        
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
    
    
    /// 上报关卡
    /// - Parameter test: 参数待定
    /// - Parameter completion: 上报后成功或失败的回调处理
    func reportUnit( completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let json = self.reportJson()
        let request = YXExerciseRequest.report(json: json)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            completion?(response.statusCode == 200, nil)
        }) { (error) in
            completion?(false, error.message)
        }
    }
    
    
    func updateScore(wordId: Int, score: Int) {
        for (i, e) in self.newExerciseModelArray.enumerated() {
            if e.word?.wordId == wordId {
                newExerciseModelArray[i].score = score
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
        YXExcerciseProgressManager.initProgressStatus()
        YXExcerciseProgressManager.updateProgress(newExerciseModel: newExerciseModelArray, reviewExerciseModel: reviewExerciseModelArray)
    }
    
    
    private func processNewWord(result: YXExerciseResultModel?) {
        // 处理新学单词
        for wordId in result?.newWords ?? [] {
            
            if let word = self.fetchWord(wordId: wordId) {
                var exercise = YXWordExerciseModel()
                exercise.question = word
                exercise.word = word
                exercise.isNewWord = true
                exercise.isFinish = true
                
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
                report.score = e.score ?? 0
                report.result = YXExerciseReportModel.ResultModel()
                
                map[e.word?.wordId ?? 0]  = report
            }            
        }
        
        for e in reviewExerciseModelArray {
            var model = map[e.word?.wordId ?? 0]
            switch e.step {
            case 1:
                model?.result?.one = e.isRight
            case 2:
                model?.result?.two = e.isRight
            case 3:
                model?.result?.three = e.isRight
            case 4:
                model?.result?.four = e.isRight
            default:
                print()
            }
        }
        
        return Array(map.values).toJSONString() ?? ""
    }
    
}

