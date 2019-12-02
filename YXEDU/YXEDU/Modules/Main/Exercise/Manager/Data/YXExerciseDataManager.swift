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
    public var progressManager: YXExcerciseProgressManager
    
    
    /// 当前第几轮, 从第一轮开始
    private var currentTurnIndex = 0
    /// 新学 和 复习的单词数量
    private var needNewStudyCount = 0, needReviewCount = 0
    /// 新学跟读集合
    private var newExerciseArray: [YXWordExerciseModel] = []
    /// 复习单词集合
    private var reviewWordArray: [YXWordStepsModel] = []
    /// 当前轮
    private var currentTurnArray: [YXWordExerciseModel] = []
    /// 上一轮
    private var previousTurnArray: [YXWordExerciseModel] = []

    
    /// 本地数据库访问
    private let dao: YXWordBookDao = YXWordBookDaoImpl()
    /// 选项生成器
    private var optionManager: YXExerciseOptionManager
    
    
    init(bookId: Int, unitId: Int) {
        self.bookId = bookId
        self.unitId = unitId
        progressManager = YXExcerciseProgressManager(bookId: bookId, unitId: unitId)
        optionManager = YXExerciseOptionManager()
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
        printReportResult()
        
        if !progressManager.isSkipNewWord() {
            for exercise in self.newExerciseArray {
                if exercise.isFinish == false {
                    return (needNewStudyCount, needReviewCount, exercise)
                }
            }
        }
        
        let e = buildExercise()
        
        // 打印
//        printCurrentTurn()
        
        // 保持当前轮次
        progressManager.setCurrentTurn(index: currentTurnIndex)
        // 取出来一个后，保存当前轮的进度
        progressManager.updateTurnProgress(currentTurnArray: currentTurnArray, previousTurnArray: previousTurnArray)

        
        return (needNewStudyCount, needReviewCount, e)
    }
    
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
    

    func hasConnectionError(wordId: Int, step: Int) -> Bool {
        for word in self.reviewWordArray {
            if word.wordId == wordId {
                for stepModel in word.exerciseSteps {
                    if let e = stepModel.first, e.step == step, let right = e.isRight {
                        return right == false
                    }
                }
                return false
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
    
    //MARK: - private - process data
    
    private func processExerciseData(result: YXExerciseResultModel?) {
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
    private func processNewWord(result: YXExerciseResultModel?) {
        // 处理新学单词
        for wordId in result?.newWordIds ?? [] {
            
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
                
                newExerciseArray.append(exercise)
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
    
    //MARK: - private - fetch data
    
    /// 出题逻辑（根据step，上轮对错）
    private func buildExercise() -> YXWordExerciseModel? {

        if currentTurnArray.count == 0 {
            currentTurnIndex += 1
            
            for (i, word) in reviewWordArray.enumerated() {
                for (j, step) in word.exerciseSteps.enumerated() {
                    if let exericse = fetchExerciseOfStep(exerciseArray: step) {
                        
                        if exericse.isFinish {// 做过
                            if exericse.isContinue == true {// 如果上一轮有做错过，需要继续做
                                for z in 0..<step.count {
                                    reviewWordArray[i].exerciseSteps[j][z].isContinue = nil
                                }
                                currentTurnArray.append(exericse)
                                break
                            }
                        } else {// 没做
                            if exericse.isNewWord {// 如果是新学，1到4步都要做
                                currentTurnArray.append(exericse)
                                break
                            } else if exericse.step == currentTurnIndex {// 复习，到指定轮次和 step 相同是才开始训练
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
        

        
        // Q-A-9
        if currentTurnArray.first?.type == .connectionWordAndChinese {
            var connectionArray: [YXWordExerciseModel] = []
            for exercise in currentTurnArray {
                if exercise.type == .connectionWordAndChinese {
                    if connectionArray.count < 4 {
                        connectionArray.append(exercise)
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
        
        // Q-A-10
        if currentTurnArray.first?.type == .connectionWordAndImage {
            var connectionArray: [YXWordExerciseModel] = []
            for exercise in currentTurnArray {
                if  exercise.type == .connectionWordAndImage {
                    if connectionArray.count < 4 {
                        connectionArray.append(exercise)
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
        guard let e = currentTurnArray.first else {
            return nil
        }
        
        // 其他题型
        return optionManager.processReviewWordOption(exercise: e)
    }
   
    
    private func sortCurrentTurn() {
        
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
   
    /// 获取练习题的备份题
    /// - Parameters:
    ///   - wordId: 单词Id
    ///   - step: 步骤
    private func backupExercise(wordId: Int, step: Int) -> YXWordExerciseModel? {
        for word in reviewWordArray {
            if word.wordId == wordId {
                return word.backupExerciseStep[String(step)]
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
        if exerciseModel.isNewWord && (exerciseModel.type == .newLearnPrimarySchool || exerciseModel.type == .newLearnPrimarySchool_Group || exerciseModel.type == .newLearnJuniorHighSchool) {
            for (i, e) in newExerciseArray.enumerated() {
                if e.word?.wordId == exerciseModel.word?.wordId {
                    newExerciseArray[i].isFinish = true
                    break
                }
            }
        } else {
            // 以下是一个练习整体做完的处理（连线题所有项全部连完）
            
            if exerciseModel.type == .connectionWordAndChinese || exerciseModel.type == .connectionWordAndImage {
                // 进入这个分支，表示连线题，所有项都完成（不管中间是否有出错）
                for item in exerciseModel.option?.firstItems ?? [] {
                    currentTurnArray.removeFirst()
                    self.updateWordStepStatus(wordId: item.optionId, step: exerciseModel.step, right: right, finish: right)
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
                
                self.updateWordStepStatus(wordId: exerciseModel.word?.wordId ?? 0, step: exerciseModel.step, right: right, finish: finish)
            }
            
        }
    }
    
    /// 更新得分
    /// - Parameters:
    ///   - exerciseModel:
    ///   - right:
    public func updateScore(wordId: Int, step: Int, right: Bool, type: YXExerciseType) {
        
        var score = 10
        
        if type == .newLearnPrimarySchool || type == .newLearnPrimarySchool_Group {// 小学新学
            return
        } else if type == .newLearnJuniorHighSchool {// 初中新学
            score = (right ? 7 : 0)
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
        
    }
    

    
    /// 错题本数据处理
    /// - Parameter wrongExercise: 练习Model
    private func addWrongBook(exerciseModel: YXWordExerciseModel) {
        
    }
    
    /// 更新待学习数 - 新学
    private func updateNeedNewStudyCount() {
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
        
        needNewStudyCount = map.count
    }
    
    /// 更新待学习数 - 复习
    private func updateNeedReviewCount() {
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
        
        needReviewCount = map.count
    }
    

    
    /// 更新每个练习的完成状态 （是否需要重做）
    /// - Parameters:
    ///   - wordId:
    ///   - step:
    ///   - right:
    public func updateWordStepStatus(wordId: Int, step: Int, right: Bool, finish: Bool) {
        for (i, word) in reviewWordArray.enumerated() {
            if word.wordId == wordId {
                for (j, stepModel) in word.exerciseSteps.enumerated() {
                    
                    for (z, e) in stepModel.enumerated() {
                        if e.step == step {
                            reviewWordArray[i].exerciseSteps[j][z].isFinish = finish
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
        exercise.isNewWord   = step.isNewWord
        
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
            }
            
        }
        
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
    
    func printReportResult() {
        let json = self.reportJson()
        print(json)
    }
    
    func printCurrentTurn() {
        print("第\(currentTurnIndex)轮数量：", currentTurnArray.count)
        for (index, e) in self.currentTurnArray.enumerated() {
            print( "id =", e.word?.wordId ?? 0, ", word =", e.word?.word ?? 0)
            print("step = ", e.step, " type = ", e.type.rawValue)

            
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

