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
    
    // ----------------------------
    //MARK: - Private 属性
    var _exerciseOptionManange = YXExerciseOptionManager()
    
    var _resultModel: YXExerciseResultModel?

    var _wordIdMap = [Int:Int]()
    
    // 当前学习记录
    var _studyRecord = YXStudyRecordModel()
    
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
        self.clearExpiredData()
        
        // 2. 加载学习状态
        self.progress = studyDao.getProgress(learn: learnConfig)
        
        // 3. 加载答题选项
        if self.progress == .learning {
            self._loadExerciseOption()
        }
    }
    
    
    /// 获取今天要学习的练习数据
    /// - Parameter completion: 数据加载成功后的回调
    func fetchExerciseResultModels(completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let planId = learnConfig.planId == 0 ? nil : learnConfig.planId
        let request = YXExerciseRequest.exercise(type: learnConfig.learnType.rawValue, planId: planId)
        YYNetworkService.default.request(YYStructResponse<YXExerciseResultModel>.self, request: request, success: { (response) in
            self._resultModel = response.data
            self._processData()
            completion?(true, nil)
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
        return self._findExercise()
    }
    
    
//    func loadLocalExercise() {
//        if let record = studyDao.selectStudyRecordModel(config: learnConfig) {
//            self.studyRecord = record
//        }
//    }

    func setStartTime() {
        let time = Date().local().timeIntervalSince1970
        // 数据库操作 - 设置时间
        self.studyDao.setStartTime(learn: learnConfig, start: Int(time))
    }

    func normalAnswerAction(exercise model: YXExerciseModel) {
        var _model = model
        let ignoreTypeArray: [YXQuestionType] = [.newLearnPrimarySchool,
                                                 .newLearnPrimarySchool_Group,
                                                 .newLearnJuniorHighSchool]
        if ignoreTypeArray.contains(_model.type) {
            // 扣分逻辑
            _model = self.updateScore(exercise: _model)
        }
        // 如果是0、7分题，先移除未做的题
        if _model.isCareScore {
            var deleteModel = _model
            deleteModel.mastered = !_model.mastered
            self.stepDao.deleteStep(with: deleteModel)
        }
        if _model.step == 0 && self.ruleType == .p3 && _model.mastered  {
            // 更新S1和S4为跳过
            self.skipStep1_4(exercise: _model)
        }
        // 保存数据到数据库
        // - 更新缓存表
        self.updateCurrentTurn(exercise: _model)
        // - 更新Step表
        self.updateStep(exercise: _model)
        // - 更新练习表
        self.updateProgress(exercise: _model)
        // - 更新学习流程表
        self.updateDurationTime()
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
                let wordCount   = self.exerciseDao.getExerciseCount(learn: self.learnConfig, includeNewWord: true, includeReviewWord: true)
                newWordCount    = self.exerciseDao.getExerciseCount(learn: self.learnConfig, includeNewWord: true, includeReviewWord: false)
                reviewWordCount = self.exerciseDao.getExerciseCount(learn: self.learnConfig, includeNewWord: false, includeReviewWord: true)
                // 上报Growing
                YXGrowingManager.share.biReport(learn: self.learnConfig, duration: duration, word: wordCount)
                if self.learnConfig.learnType == .base {
                    YXGrowingManager.share.uploadLearnFinished()
                    // 记录学完一次主流程，用于首页弹出设置提醒弹框
                    YYCache.set(true, forKey: "DidFinishMainStudyProgress")
                }
                
                // 清除数据库对应数据
                self.deleteLearnRecord()
            }
            completion?(result, ["newWordCount":newWordCount, "reviewWordCount":reviewWordCount])
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, [:])
        }
    }
    
    func isShowWordDetail(wordId: Int, step: Int) -> Bool {
        return false
    }
    
    func hasErrorInCurrentTurn(wordId: Int, step: Int) {
        
    }
    
    func cleanExercise() -> Bool {
        // studyDao.getStudyID(learn: learnConfig)
        let studyId = _studyRecord.studyId
        if studyId > 0 {
            let r1 = studyDao.delete(study: studyId)
            let r2 = exerciseDao.deleteExercise(study: studyId)
            let r3 = stepDao.deleteStepWithStudy(study: studyId)
            let r4 = turnDao.deleteCurrentTurn(studyId: studyId)
            
            YXLog("删除当前学习记录 studyId=", studyId, r1, r2, r3, r4)
            return r1 && r2 && r3 && r4
        }
        YXLog("删除当前学习记录失败, studyId=", studyId)
        return false
    }
    
    // ----------------------------
    //MARK: - Private 方法
    /// 获取上报内容
    private func getReportJson() -> String {
        var modelArray = [YXExerciseReportModel]()
        // 获得所有学习的单词单词
        let exerciseModelList = self.exerciseDao.getExerciseList(learn: self.learnConfig, includeNewWord: false, includeReviewWord: true)

        exerciseModelList.forEach { (model) in
            let data = self.stepDao.getSteps(with: model)
            var _model = YXExerciseReportModel()
            _model.wordId     = model.word?.wordId ?? 0
            _model.bookId     = model.word?.bookId
            _model.unitId     = model.word?.unitId
            _model.score      = model.score
            _model.errorCount = model.wrongCount
            _model.result     = ResultModel(JSON: data)
            modelArray.append(_model)
        }
        return modelArray.toJSONString() ?? ""
    }

    /// 获取学习时长
    private func getLearnDuration() -> Int {
        return self.studyDao.getDurationTime(learn: learnConfig)
    }

    func getNewWordCount() -> Int {
        return self.exerciseDao.getNewWordCount()
    }

    func getReviewWordCount() -> Int {
        return self.exerciseDao.getReviewWordCount()
    }

    /// 更新学习时间
    func updateDurationTime() {
        let currentTime = Int(Date().local().timeIntervalSince1970)
        let startTime   = self.studyDao.getStartTime(learn: learnConfig)
        let duration    = currentTime - startTime
        self.studyDao.setDurationTime(learn: learnConfig, duration: duration)
    }

    /// 扣分逻辑
    private func updateScore(exercise model: YXExerciseModel) -> YXExerciseModel {

        var _model      = model
        if model.mastered {
            _model.score -= model.result == .some(true) ? 0 : model.wrongScore * model.wrongRate
        } else {
            _model.score -= model.result == .some(true) ? 0 : model.wrongScore
        }
        _model.score = _model.score < 0 ? 0 : _model.score
        // 更新单词得分
        return _model
    }
    
    /// 更新缓存表
    private func updateCurrentTurn(exercise model: YXExerciseModel) {
        self.turnDao.updateExerciseFinishStatus(stepId: model.stepId)
    }

    /// 更新Step数据库
    private func updateStep(exercise model: YXExerciseModel) {
        self.stepDao.updateStep(exerciseModel: model)
    }

    /// 跳过Step1-4
    @discardableResult
    private func skipStep1_4(exercise model: YXExerciseModel) -> Bool {
        self.stepDao.skipStep1_4(exercise: model)
    }

    /// 更新进度
    private func updateProgress(exercise model: YXExerciseModel) {
        if model.status == .right {
            var _model = model
            _model.unfinishStepCount -= 1
            self.exerciseDao.updateExercise(exercise: _model)
        }
    }

    /// 删除当前学习记录
    private func deleteLearnRecord() {
        let studyId = self.studyDao.getStudyID(learn: learnConfig)
        self.studyDao.delete(study: studyId)
        self.exerciseDao.deleteExercise(study: studyId)
        self.stepDao.deleteStepWithStudy(study: studyId)
        YXLog("清除\(learnConfig.learnType.rawValue)的学习记录完成, Plan ID:", learnConfig.planId ?? 0)
    }

}
