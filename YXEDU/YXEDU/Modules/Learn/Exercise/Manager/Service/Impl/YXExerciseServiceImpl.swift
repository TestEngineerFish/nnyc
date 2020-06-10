//
//  YXExerciseServiceImpl.swift
//  YXEDU
//
//  Created by sunwu on 2020/5/15.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
// 供练习VC调用
class YXExerciseServiceImpl: YXExerciseService {

    // ----------------------------
    //MARK: - 属性
    var learnConfig: YXLearnConfig = YXBaseLearnConfig()
    
    var ruleType: YXExerciseRule = .p0
        
    var progress: YXExerciseProgress = .none
    
    var newWordCount: Int { return getNewWordCount() }
    
    var reviewWordCount: Int { return getReviewWordCount() }
    
    // ----------------------------
    //MARK: - Private 属性
    var _exerciseOptionManange = YXExerciseOptionManager()
    
    var _resultModel: YXExerciseResultModel?

    var _wordIdMap = [Int:Int]()
    
    // 当前学习记录
    var _studyRecord = YXStudyRecordModel()
    var _studyId: Int { return _studyRecord.studyId }
        

    /// 本地数据库访问
    var wordDao: YXWordBookDao     = YXWordBookDaoImpl()
    var studyDao: YXStudyRecordDao = YXStudyRecordDaoImpl()
    var exerciseDao: YXExerciseDao = YXExerciseDaoImpl()
    var stepDao: YXWordStepDao     = YXWordStepDaoImpl()
    var turnDao: YXCurrentTurnDao  = YXCurrentTurnDaoImpl()
    
    // ----------------------------
    
    //MARK: ==== 对外暴露的方法 ====
    
    func initService() {
        // 1.清除过期数据
        self._clearExpiredData()
        
        // 2. 加载学习进度
        self._loadStudyPropress()
    }

    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchExerciseResultModels(completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let planId = learnConfig.planId == 0 ? nil : learnConfig.planId
        let request = YXExerciseRequest.exercise(type: learnConfig.learnType.rawValue, planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { [weak self] (response) in
            self?._resultModel = response.data
            self?._processData {
                completion?(true, nil)
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, error.message)
        }
    }
    
    /// 获取一个练习数据
    func fetchExerciseModel() -> YXExerciseModel? {        
        // 加载学习记录信息
        self._loadStudyRecord()
        
        // 筛选数据
        self._filterExercise()
        
        // 查找练习
        let model = self._findExercise()
        
        // 打印
        self._printCurrentTurn()
        return model
    }
    

    func addStudyCount() {
        self.studyDao.addStudyCount(studyId: _studyId)
    }

    func setStartTime() {
        self.studyDao.setStartTime(studyId: _studyId)
    }

    func updateDurationTime() {
        let currentTime  = Date()
        let startTimeStr = self.studyDao.getStartTime(learn: learnConfig)
        if let startTime = NSDate(string: startTimeStr, format: NSDate.ymdHmsFormat()) {
            let duration = currentTime.timeIntervalSince(startTime as Date)
            self.studyDao.setDurationTime(studyId: _studyId, duration: Int(duration))
            self.setStartTime()
        }
    }

    func answerAction(exercise: YXExerciseModel) {
        if exercise.isBackup {
            if var model = stepDao.selectOriginalWordStepModelByBackup(studyId: _studyId, wordId: exercise.wordId, step: exercise.step) {
                model.status = exercise.status
                normalAnswerAction(exercise: model)
            }
        } else if exercise.step == 0 && exercise.type == .newLearnMasterList {
            n3AnswerAction(exercise: exercise)
        } else {
            normalAnswerAction(exercise: exercise)
        }
    }
    
    func normalAnswerAction(exercise model: YXExerciseModel) {
        // 如果是0、7分题，先移除未做的题
        if model.isCareScore {
            var deleteModel = model
            deleteModel.mastered = !model.mastered
            YXLog(model.mastered ? "已" : "未", "掌握，移除", model.mastered ? "0":"7", "分题")
            self.stepDao.deleteStep(with: deleteModel)
        }
        let skipStep1_4TypeList: [YXExerciseRule] = [.p0, .p3, .p4]
        if model.step == 0 && skipStep1_4TypeList.contains(self.ruleType) && model.mastered  {
            // 更新S1和S4为跳过
            YXLog("P3，新学已掌握，标记Step1和Step4为跳过")
            self.skipStep1_4(exercise: model)
        }
        // 保存数据到数据库
        // - 更新缓存表
        self.updateCurrentTurn(exercise: model)
        // - 更新Step表
        self.updateStep(exercise: model)
        // - 更新练习表
        self.updateExercise(exercise: model)
        // - 更新学习流程表
        self.updateDurationTime()
    }
    
    
    
    func n3AnswerAction(exercise: YXExerciseModel) {
        for model in exercise.n3List {
            self.normalAnswerAction(exercise: model)
        }
    }
    
    
    func connectionAnswerAction(wordId: Int, step: Int, right: Bool) {        
        // 把连线题的子项查出来
        if var model = stepDao.selectWordStepModel(studyId: _studyId, wordId: wordId, step: step) {
            model.status = right ? .right : .wrong
            
            // - 更新Step表 [更新完成状态 和 错误次数]
            self.updateStep(exercise: model)
            
            // - 更新练习表
            self.updateExercise(exercise: model)
        }
    }
    
    func updateConnectionExerciseFinishStatus(exerciseModel: YXExerciseModel, right: Bool) {
        for item in exerciseModel.option?.firstItems ?? [] {
            turnDao.updateExerciseFinishStatus(studyId: _studyId, wordId: item.optionId)
        }
    }
    
    
    /// 上报关卡
    func report(completion: ((_ result: Bool, _ dict: [String:Int]) -> Void)?) {
        let reportContent = self.getReportJson()
        let duration      = self.getLearnDuration()
        YXLog("====上报数据====")
        YXLog("new上报内容：" + reportContent)
        YXLog("new学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: learnConfig.learnType.rawValue, time: duration, result: reportContent)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            let result = response.dataArray != nil
            var newWordCount    = 0
            var reviewWordCount = 0
            if result {
                // 获取学习数据
                let duration    = self.studyDao.getDurationTime(learn: self.learnConfig)
                let studyCount   = self.studyDao.selectStudyRecordModel(config: self.learnConfig)?.studyCount ?? 0
                newWordCount    = self.exerciseDao.getExerciseCount(studyId: self._studyId, includeNewWord: true, includeReviewWord: false)
                reviewWordCount = self.exerciseDao.getExerciseCount(studyId: self._studyId, includeNewWord: false, includeReviewWord: true)
                // 上报Growing
                YXGrowingManager.share.biReport(learn: self.learnConfig, duration: duration, study: studyCount)
                if self.learnConfig.learnType == .base {
                    YXGrowingManager.share.uploadLearnFinished()
                    // 记录学完一次主流程，用于首页弹出设置提醒弹框
                    YYCache.set(true, forKey: "DidFinishMainStudyProgress")
                }
                
                // 清除数据库对应数据
                self.cleanStudyRecord()
            }
            completion?(result, ["newWordCount":newWordCount, "reviewWordCount":reviewWordCount])
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, [:])
        }
    }
    
    /// 是否显示单词详情页
    /// P2  跳过新学，做题时首次做新学词题目后无论对错必定出现单词详情
    func isShowWordDetail(wordId: Int, step: Int) -> Bool {
        guard let data = stepDao.selectMinStepWrongCount(studyId: _studyId, wordId: wordId) else {
            return false
        }
        
        return ruleType == .p2 && data.0 == step && data.1 == 0
    }
    
    // 备份，后续显示详情配置到step上后再启用
    func isShowWordDetail_backup(wordId: Int, step: Int) -> Bool {
        if let model = stepDao.selectWordStepModel(studyId: _studyId, wordId: wordId, step: step) {
            switch model.question?.extend?.isShowWordDetail ?? .none {
            case .none:
                // 对错都不显示
                return false
            case .all:
                // 对错都要显示
                return true
            case .right:
                // 答对并且是首次作答，要显示
                return model.status == .right && model.wrongCount == 0
            case .wrong:
                // 答错时显示
                return model.status == .wrong
            }
        }
        return false
    }
    
    /// 当前轮，有没有做错
    func hasErrorInCurrentTurn(wordId: Int, step: Int) -> Bool {
        if let model = stepDao.selectWordStepModel(studyId: _studyId, wordId: wordId, step: step) {
            return model.status == .wrong
        }
        return false
    }
    
    func cleanStudyRecord() {
        let studyId = _studyRecord.studyId
        if studyId > 0 {
            let r1 = studyDao.delete(study: studyId)
            let r2 = exerciseDao.deleteExercise(study: studyId)
            let r3 = stepDao.deleteStepWithStudy(study: studyId)
            let r4 = turnDao.deleteCurrentTurn(studyId: studyId)
            
            YXLog("清除学习记录完成 ", learnConfig.desc)
            YXLog("删除当前学习记录 studyId=", studyId, r1, r2, r3, r4)
        } else {
            YXLog("删除当前学习记录失败, studyId=", studyId, learnConfig.desc)
        }
    }

    func cleanAllStudyRecord() {
        let r1 = studyDao.deleteAllStudyRecord()
        let r2 = exerciseDao.deleteAllExercise()
        let r3 = stepDao.deleteAllWordStep()
        let r4 = turnDao.deleteAllExpiredTurn()
        YXLog("删除所有学习记录", r1, r2, r3, r4)
    }
    
}
