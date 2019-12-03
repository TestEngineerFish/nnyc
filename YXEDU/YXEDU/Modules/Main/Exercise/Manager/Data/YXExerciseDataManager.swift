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
    /// 哪本书，哪个单元
    public var bookId: Int = 0, unitId: Int = 0
    /// 进度管理器
    public var progressManager: YXExcerciseProgressManager!
    
    
    /// 当前第几轮, 从第一轮开始
    var currentTurnIndex = 0
    /// 新学 和 复习的单词数量
    var needNewStudyCount = 0, needReviewCount = 0
    
    /// 新学跟读集合
    var newExerciseArray: [YXWordExerciseModel] = []
    /// 复习单词集合
    var reviewWordArray: [YXWordStepsModel] = []
    /// 当前轮
    var currentTurnArray: [YXWordExerciseModel] = []
    /// 上一轮
    var previousTurnArray: [YXWordExerciseModel] = []

    
    /// 本地数据库访问
    var dao: YXWordBookDao!
    /// 选项生成器
    var optionManager: YXExerciseOptionManager!
    
    
    init(bookId: Int, unitId: Int) {
        super.init()
        self.bookId     = bookId
        self.unitId     = unitId
        
        dao             = YXWordBookDaoImpl()
        optionManager   = YXExerciseOptionManager()
        progressManager = YXExcerciseProgressManager(bookId: bookId, unitId: unitId)
    }
    
    
    //MARK: ----- fetch data
    
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
    func fetchLocalExerciseModels() {
        let data = progressManager.loadLocalExerciseModels()
        newExerciseArray = data.0
        reviewWordArray = data.1
        
        let turnData = progressManager.loadLocalTurnData()
        currentTurnArray = turnData.0
        previousTurnArray = turnData.1
                
        currentTurnIndex = progressManager.currentTurnIndex()
        
        optionManager.initData(newArray: newExerciseArray, reviewArray: self.reviewWords())
    }

    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> (Int, Int, YXWordExerciseModel?) {
        // 更新待学习数
        updateNeedNewStudyCount()
        updateNeedReviewCount()
        
        // 打印
//        printReportResult()
        
        if !progressManager.isSkipNewWord() {
            for exercise in self.newExerciseArray {
                if exercise.isFinish == false {
                    return (needNewStudyCount, needReviewCount, exercise)
                }
            }
        }
        
        let e = buildExercise()
        
        // 打印
        printCurrentTurn()
        
        // 保持当前轮次
        progressManager.setCurrentTurn(index: currentTurnIndex)
        // 取出来一个后，保存当前轮的进度
        progressManager.updateTurnProgress(currentTurnArray: currentTurnArray, previousTurnArray: previousTurnArray)
        
        return (needNewStudyCount, needReviewCount, e)
    }
    
    
    //MARK:  ----- update data
    /// 做题动作，不管答题对错，都需要调用次方法修改相关状态（连线题单个选项的对错有其他的方法处理）
    /// - Parameters:
    ///   - exerciseModel: 练习数据
    ///   - right: 对错
    func defaultAnswerAction(exerciseModel: YXWordExerciseModel, right: Bool) {
        
        // 更新每个练习的完成状态
        updateFinishStatus(exerciseModel: exerciseModel, right: right)
        
        // 更新积分
        updateScore(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right, type: exerciseModel.type)
        
        // 更新对错
        updateStepRightOrWrongStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right)
        
        // 更新进度状态
        progressManager.updateProgress(newWordArray: newExerciseArray, reviewWordArray: reviewWordArray)

        // 打印
//        printStatus()
                    
    }
    
    
    
    /// 连线题，单个选项的做题动作处理
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    ///   - right:
    ///   - type:
    func connectionAnswerAction(wordId: Int, step: Int, right: Bool, type: YXExerciseType) {
        updateScore(wordId: wordId, step: step, right: right, type: type)
        updateStepRightOrWrongStatus(wordId: wordId, step: step, right: right)
        updateWordStepStatus(wordId: wordId, step: step, right: right, finish: false)
        
        // 更新进度状态
        progressManager.updateProgress(newWordArray: newExerciseArray, reviewWordArray: reviewWordArray)
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
    
    
    /// 是否连线错误
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    func hasConnectionError(wordId: Int, step: Int) -> Bool {
        for e in currentTurnArray {
            if e.word?.wordId == wordId && e.step == step, let right = e.isRight {
                return right == false
            }
        }
        return false
    }
    
    func skipNewWord() {
        progressManager.setSkipNewWord()
    }
    

    func fetchWord(wordId: Int) -> YXWordModel? {
        return dao.selectWord(wordId: wordId)
    }
    
    
    private func reportJson() -> String {
        var map: [Int : YXExerciseReportModel] = [:]
        
        for word in reviewWordArray {
            
            if let _ = map[word.wordId] {
                continue
            } else {
                
                // 查找不为空的一个对象
                var e: YXWordExerciseModel?
                for step in word.exerciseSteps {
                    if step.count > 0 {
                        e = step.first
                        break
                    }
                }
                
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
            }
            
        }
        
        return Array(map.values).toJSONString() ?? ""
    }
    
    
    //MARK: ----- print
    
    func printReportResult() {
        let json = self.reportJson()
        print(json)
    }
    
    func printCurrentTurn() {
        print("第\(currentTurnIndex)轮数量：", currentTurnArray.count)
        for e in self.currentTurnArray {
            print( "id =", e.word?.wordId ?? 0, ", word =", e.word?.word ?? 0)
            print("step = ", e.step, " type = ", e.type.rawValue, "turn_finish", e.isCurrentTurnFinish)

            
            print("--------------------")
        }
    }
    func printStatus() {
        
        print("$$$$$$$$$$#############$$$$$$$$$$$$")
        for word in self.reviewWordArray {
            print("\n========================\n")
            for (index, step) in word.exerciseSteps.enumerated() {
                let e = step.first
                
                print("\t\tid ", word.wordId, ", step", e?.step ?? 0, ", index", index + 1)
//                print("\n")
                print( "id =", e?.word?.wordId ?? 0, ", word =", e?.word?.word ?? 0)
                print("right =", e?.isRight ?? "nil", ", continue =", e?.isContinue ?? "nil", ", finish =", e?.isFinish ?? "nil")
                
                print("--------------------")
            }
            
        }
        
        
    }
}

