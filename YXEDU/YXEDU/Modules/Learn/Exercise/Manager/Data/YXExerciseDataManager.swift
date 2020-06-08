//
//  YXExerciseDataManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import ObjectMapper

@objc enum YXLearnType: Int {
    case base = 1               // 基础学习
    case wrong = 2              // 抽查
    case planListenReview = 3   // 计划——听力复习
    case planReview = 4         // 计划——复习
    case aiReview = 5           // 智能复习

    static func transform(raw: Int) -> YXLearnType {
        switch raw {
        case 1:
            return .base
        case 2:
            return .wrong
        case 3:
            return .planListenReview
        case 4:
            return .planReview
        case 5:
            return .aiReview
        default:
            return .base
        }
    }
}


/// 数据状态
enum YXExerciseDataStatus: Int {
    case empty  // 没数据
    case finish // 学完
}

/// 练习的数据管理器
class YXExerciseDataManager: NSObject {
    /// 哪本书，哪个单元
    public var bookId: Int?, unitId: Int?
    public var dataType: YXLearnType = .base
    public var ruleType: YXExerciseRule = .p0
    
    /// 进度管理器
    public var progressManager: YXExcerciseProgressManager!
    
    public var dataStatus: YXExerciseDataStatus = .finish
    
    /// 当前批次，一次学习分成了多批
    var currentBatchIndex = 0
    /// 当前第几轮, 从第一轮开始
    var currentTurnIndex = 0
    
    /// 每批新学的大小限制
    var newWordBatchSize: Int { return newWordBatchSizeConfig() }
    /// 每批复习的大小限制
    var reviewWordBatchSize: Int { return reviewWordBatchSizeConfig() }
    
    
    var isChangeBatch = true
    /// 新学 和 复习的单词数量
    var needNewStudyCount = 0, needReviewCount = 0
    
    /// 新学跟读集合
    var newWordArray: [YXExerciseModel] = []
    /// 训练和复习单词集合
    var reviewWordArray: [YXWordStepsModel] = []
    
    /// 新Step集合，按组归类
    var stepArray: [[String:[Any]]] = []
    
    // 训练单词的Id集合，复习单词的Id集合
    var exerciseWordIdArray: [Int] = [], reviewWordIdArray: [Int] = []
    
    /// 当前轮
    var currentTurnArray: [YXExerciseModel] = []
    
    /// 本地数据库访问
    var dao: YXWordBookDao!
    /// 选项生成器
    var optionManager: YXExerciseOptionManager!
    
    // 一批学完后，重置下标
    var isResetTurnIndex = true
    
    override init() {
        super.init()
        dao             = YXWordBookDaoImpl()
        optionManager   = YXExerciseOptionManager()
        progressManager = YXExcerciseProgressManager()
        NotificationCenter.default.addObserver(self, selector: #selector(removeStep1_4(_:)), name: YXNotification.kNewWordMastered, object: nil)
    }

    /// 新学标记已掌握，能力值等于10，将移除Step1和4的题型
    @objc private func removeStep1_4(_ notification: Notification) {
        guard let wordId = notification.userInfo?["id"] as? Int else {
            return
        }
        for (index, model) in self.reviewWordArray.enumerated() {
            if model.wordId == wordId {
                if model.exerciseSteps.first?.first?.step == 1 {
                    self.reviewWordArray[index].exerciseSteps.removeFirst()
                }
                if model.exerciseSteps.last?.last?.step == 4 {
                    self.reviewWordArray[index].exerciseSteps.removeLast()
                }
            }
        }

    }
    
    
    //MARK: ----- fetch data
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchTodayExerciseResultModels(type: YXLearnType, planId: Int? = nil, completion: @escaping ((_ result: Bool, _ msg: String?) -> Void)) {
        let request = YXExerciseRequest.exercise(type: type.rawValue, planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            self.processExerciseData(result: response.data)
            completion(true, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion(false, error.message)
        }
    }
    
    /// 加载本地未学完的关卡数据
    @discardableResult
    func fetchLocalExerciseModels() -> Bool {
        YXLog("加载本地未学完的关卡数据")
        isResetTurnIndex = false
        
        if progressManager.dataType != .base {
            let bau = progressManager.fetchBookIdAndUnitId()
            self.bookId = bau.0
            self.unitId = bau.1
            progressManager.bookId = self.bookId
            progressManager.unitId = self.unitId
            YXLog("加载的本地数据是基础学习，则赋值正确的BookID：\(self.bookId ?? 0)和单元ID\(self.unitId ?? 0)")
        }
        
        let data = progressManager.loadLocalExerciseModels()
        // 如果无法生成题型，则不从本地获取数据，重新从网络获取
        if data.0.first?.type == .some(.none) {
            return false
        }
        newWordArray    = data.0
        reviewWordArray = data.1
        
        exerciseWordIdArray = progressManager.loadNewWordExerciseIds()
        for e in reviewWordArray {
            // 不是训练的，就是复习单词
            if exerciseWordIdArray.contains(e.wordId) == false {
                reviewWordIdArray.append(e.wordId)
            }
        }

        if (newWordArray.count == 0 && reviewWordArray.count == 0) {
            dataStatus = .empty
        }
        
        ruleType = progressManager.ruleType()
        YXLog("==== 当前学习规则: 【", ruleType.rawValue, "】 ====")
        let turnData = progressManager.loadLocalTurnData()
        currentTurnArray = turnData
                
        currentTurnIndex = progressManager.currentTurnIndex()
        
        optionManager.initOption(newArray: newWordArray, reviewArray: self.reviewWords())
        return true
    }

    
    /// 从当前关卡数据中，获取一个练习数据对象
    func fetchOneExerciseModel() -> YXExerciseModel? {
        // 打印
        printCurrentTurn()

        // 新学出题【跟读】
        if let e = buildNewExercise() {
            return e
        }
        
        // 生成题型【训练+复习】
        var e = buildExercise()
        let wid = e?.word?.wordId ?? 0
        e?.word = selectWord(wordId: wid)
        

        
        // 保持当前轮次
        progressManager.setCurrentTurn(index: currentTurnIndex)
        // 取出来一个后，保存当前轮的进度
        progressManager.updateTurnProgress(currentTurnArray: currentTurnArray)
        return e
    }
    
    
    //MARK:  ----- update data
    /// 做题动作，不管答题对错，都需要调用次方法修改相关状态（连线题单个选项的对错有其他的方法处理）
    /// - Parameters:
    ///   - exerciseModel: 练习数据
    ///   - right: 对错
    func normalAnswerAction(exerciseModel: YXExerciseModel, right: Bool) {
        
        // 更新每个练习的完成状态
        updateNormalExerciseFinishStatus(exerciseModel: exerciseModel, right: right)
        
        // 更新积分
        updateQuestionTypeScore(exerciseModel: exerciseModel)
        updateWordScore(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right, type: exerciseModel.type, isDouble: exerciseModel.mastered)
        
        // 更新对错
        updateStepRightOrWrongStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right)
        
        // 更新进度状态
        progressManager.updateProgress(newWordArray: newWordArray, reviewWordArray: reviewWordArray)

        // 打印
//        printStatus()
                    
    }
    
    
    
    /// 连线题，仅单个选项的做题动作处理
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    ///   - right:
    ///   - type:
    func connectionAnswerAction(wordId: Int, step: Int, right: Bool, type: YXQuestionType) {
        
        // 更新单个项的完成状态
        updateWordStepStatus(wordId: wordId, step: step, right: right, finish: false)
        
        // 更新积分
        updateWordScore(wordId: wordId, step: step, right: right, type: type)
        
        // 更新对错
        updateStepRightOrWrongStatus(wordId: wordId, step: step, right: right)
        
        // 更新进度状态
        progressManager.updateProgress(newWordArray: newWordArray, reviewWordArray: reviewWordArray)
    }
        

    
    /// 上报关卡
    /// - Parameter test: 参数待定
    /// - Parameter completion: 上报后成功或失败的回调处理
    func reportExercise(type: YXLearnType, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let result = self.reportJson()
        YXLog("上报内容：" + result)
        let duration = progressManager.fetchStudyDuration()
        YXLog("学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: type.rawValue, time: duration, result: result)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
            completion?(response.dataArray != nil, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, error.message)
        }
    }
    
    
    /// 在当前轮次中，是否有连线错误
    /// - Parameters:
    ///   - wordId: 单词ID
    ///   - step:   step
    func hasErrorInCurrentTurn(wordId: Int, step: Int) -> Bool {
        for e in currentTurnArray {
            if e.word?.wordId == wordId && e.step == step, let right = e.isRight {
                return right == false
            }
        }
        return false
    }
    

//    func fetchWord(bookId: Int, wordId: Int) -> YXWordModel? {
//        return dao.selectWord(bookId: bookId, wordId: wordId)
//    }
    
    
    private func reportJson() -> String {
        var map: [Int : YXExerciseReportModel] = [:]
        
        for word in reviewWordArray {
            
            if let _ = map[word.wordId] {
                continue
            } else {

                /**
                // 查找不为空的一个对象，有些单词可能第一或者第二步没有，只有后面几步的情况
                var e: YXWordExerciseModel?
                for step in word.exerciseSteps {
                    if step.count > 0 {
                        e = step.first
                        break
                    }
                }
                 */
                
                var report = YXExerciseReportModel()
                report.wordId = word.wordId
                report.bookId = self.bookId
                report.unitId = self.unitId
                report.score  = progressManager.fetchScore(wordId: word.wordId)
                report.errorCount = progressManager.fetchErrorCount(wordId: word.wordId)
                report.result = ResultModel()
                
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
                default: break
                }
            }
            
        }
        
        return Array(map.values).toJSONString() ?? ""
    }
    
    
    //MARK: ----- print
    
    func printCurrentTurn() {
        YXLog(String(format: "第\(currentTurnIndex)轮数量：%ld", currentTurnArray.count))
        for e in self.currentTurnArray {
            YXLog(String(format: "id = %ld, word = %@", e.word?.wordId ?? 0, e.word?.word ?? ""))
            YXLog(String(format: "step = %ld, type = %@, turn_finish = %ld", e.step, e.type.rawValue, e.isCurrentTurnFinish))
        }
    }
    func printStatus() {
        
        YXLog("$$$$$$$$$$#############$$$$$$$$$$$$")
        for word in self.reviewWordArray {
            YXLog("\n========================\n")
            for (index, step) in word.exerciseSteps.enumerated() {
                let e = step.first
                YXLog(String(format: "\t\tid = %ld, step = %ld, index = %ld", word.wordId, e?.step ?? 0, index + 1))
                YXLog(String(format: "id = %ld, word = %@", e?.word?.wordId ?? 0, e?.word?.word ?? 0))
                YXLog(String(format: "right = %ld, continue = %ld, finish = %ld", e?.isRight ?? -1, e?.isContinue ?? -1, e?.isFinish ?? -1))
                YXLog("--------------------")
            }
            
        }
        
        
    }
}

