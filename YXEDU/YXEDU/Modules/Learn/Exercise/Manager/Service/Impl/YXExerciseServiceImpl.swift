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
    /// 本地数据库访问
    var wordDao: YXWordBookDao     = YXWordBookDaoImpl()
    var studyDao: YXStudyRecordDao = YXStudyRecordDaoImpl()
    var exerciseDao: YXExerciseDao = YXExerciseDaoImpl()
    var stepDao: YXWordStepDao     = YXWordStepDaoImpl()

    
    // ----------------------------
    
    //MARK: ==== 对外暴露的方法 ====
    func fetchExerciseModel() -> YXExerciseModel? {
        // 从缓存表中获取
        let model = self.queryExerciseModel()
        // 如果缓存表没有可做题型，添加新的可做题型

        fetchExerciseResultModels(planId: learnConfig.planId, completion: nil)
        
        self.clearExpiredData()
//        self.updateProgress()
        
        return model
    }

    func setStartTime() {
        let time = Date().local().timeIntervalSince1970
        // 数据库操作 - 设置时间
        self.studyDao.setStartTime(learn: learnConfig, start: Int(time))
    }

    func updateDurationTime() {
        let currentTime = Int(Date().local().timeIntervalSince1970)
        let startTime = self.studyDao.getStartTime(learn: learnConfig)
        let duration = currentTime - startTime
        self.studyDao.setDurationTime(learn: learnConfig, duration: duration)
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
    }

    /// 上报关卡
    func report(type: YXLearnType, plan id: Int?, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let reportContent = self.getReportJson(type: type, plan: id)
        let duration      = self.getLearnDuration(type: type, plan: id)
        YXLog("上报内容：" + reportContent)
        YXLog("学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: type.rawValue, time: duration, result: reportContent)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
            // 清除数据库对应数据
            completion?(response.dataArray != nil, nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(false, error.message)
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
    private func getReportJson(type: YXLearnType, plan id: Int?) -> String {
        var modelArray = [YXExerciseReportModel]()
        // 获得所有学习的单词单词
        let exerciseModelList = self.exerciseDao.getAllExercise(type: type, plan: id)

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
    private func getLearnDuration(type: YXLearnType, plan id: Int?) -> Int {
        return self.studyDao.getDurationTime(learn: learnConfig)
    }

    /// 扣分逻辑
    func updateScore(exercise model: YXExerciseModel) -> YXExerciseModel {

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

}
