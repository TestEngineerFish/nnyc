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
    
    var ruleType: YXExerciseRuleType = .p0
    
    var exerciseProgress: YXExerciseProgress = .reported
    
    var _resultModel: YXExerciseResultModel?

    var wordIdMap = [Int:Int]()
    
    
    
    // ----------------------------
    //MARK: - Private 属性
    
    /// 当前第几轮, 从第一轮开始
    var currentTurnIndex = -1
    
    
    /// 本地数据库访问
    var wordDao: YXWordBookDao     = YXWordBookDaoImpl()
    var studyDao: YXStudyRecordDao = YXStudyRecordDaoImpl()
    var exerciseDao: YXExerciseDao = YXExerciseDaoImpl()
    var stepDao: YXWordStepDao     = YXWordStepDaoImpl()
    var turnDao: YXCurrentTurnDao  = YXCurrentTurnDaoImpl()
    
    // ----------------------------
    
    //MARK: ==== 对外暴露的方法 ====
    
    func initData() {
//        self.clearExpiredData()
        self.loadProgressStatus()
    }
    
    
    func fetchExerciseModel() -> YXExerciseModel? {
        // 筛选数据
        self._filterExercise()
        
        // 查找类型
        return self._findExercise()
    }

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
        // 保存数据到数据库
        self.updateStep(exercise: _model)
        // 更新单词状态
        self.updateProgress(exercise: _model)
        // 更新学习时长
        self.updateDurationTime()
    }

    func isStudyFinished() -> Bool? {
        return self.studyDao.isFinished(learn: learnConfig)
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
                let wordCount   = self.exerciseDao.getAllExerciseCount(learn: self.learnConfig)
                newWordCount    = self.exerciseDao.getNewWordCount(learn: self.learnConfig)
                reviewWordCount = self.exerciseDao.getReviewWordCount(learn: self.learnConfig)
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
    
    
    // ----------------------------
    //MARK: - Private 方法
    /// 获取上报内容
    private func getReportJson() -> String {
        var modelArray = [YXExerciseReportModel]()
        // 获得所有学习的单词单词
        let exerciseModelList = self.exerciseDao.getAllExercise(learn: learnConfig)

        exerciseModelList.forEach { (model) in
            let data = self.stepDao.getSteps(with: model)
            var _model = YXExerciseReportModel()
            _model.wordId     = model.word?.wordId ?? 0
            _model.bookId     = model.word?.bookId
            _model.unitId     = model.word?.unitId
            _model.score      = data.1
            _model.errorCount = model.wrongCount
            _model.result     = ResultModel(JSON: data.0)
            modelArray.append(_model)
        }
        return modelArray.toJson()
    }

    /// 获取学习时长
    private func getLearnDuration() -> Int {
        return self.studyDao.getDurationTime(learn: learnConfig)
    }

    /// 更新学习时间
    func updateDurationTime() {
        let currentTime = Int(Date().local().timeIntervalSince1970)
        let startTime = self.studyDao.getStartTime(learn: learnConfig)
        let duration = currentTime - startTime
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

    /// 更新Step数据库
    private func updateStep(exercise model: YXExerciseModel) {
        self.stepDao.updateExercise(exerciseModel: model)
    }

    /// 更新进度
    private func updateProgress(exercise model: YXExerciseModel) {
        if model.result == .some(true) {
            var _model = model
            _model.unfinishStepCount -= 1
            self.exerciseDao.updateExercise(exercise: _model)
            if _model.unfinishStepCount == 0 {
                if model.isNewWord {
                    // 发通知
                } else {
                    // 发通知
                }
            }
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
