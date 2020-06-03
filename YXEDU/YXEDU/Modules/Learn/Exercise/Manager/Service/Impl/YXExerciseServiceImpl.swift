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
    
    // ----------------------------
    //MARK: - Private 属性
    /// 本地数据库访问
    var wordDao: YXWordBookDao     = YXWordBookDaoImpl()
    var studyDao: YXStudyRecordDao = YXStudyRecordDaoImpl()
    var exerciseDao: YXExerciseDao = YXExerciseDaoImpl()
    var stepDao: YXWordStepDao     = YXWordStepDaoImpl()

    
    // ----------------------------
    
    //MARK: - 方法
    func fetchExerciseModel() -> YXWordExerciseModel? {
        fetchExerciseResultModels(planId: learnConfig.planId, completion: nil)
        
        self.clearExpiredData()
//        self.updateProgress()
        
        return self.queryExerciseModel()
    }

    /// 设置开始学习时间
    func setStartTime(type: YXExerciseDataType, plan id: Int?) {
        let time = Date().local().timeIntervalSince1970
        // 数据库操作 - 设置时间
    }

    /// 更新学习时长
    func updateDurationTime(type: YXExerciseDataType, plan id: Int?) {
        let startTime = Date().local().timeIntervalSince1970 // 数据库查询得到
        // 数据库操作 - 更新时间
    }

    /// 做题动作，不管答题对错，都需要调用次方法修改相关状态
    /// - Parameters:
    ///   - model: 练习对象
    func normalAnswerAction(exercise model: YXWordExerciseModel) {
        var _model = model
        let ignoreTypeArray: [YXQuestionType] = [.newLearnPrimarySchool,
                                                 .newLearnPrimarySchool_Group,
                                                 .newLearnJuniorHighSchool]
        if ignoreTypeArray.contains(_model.type) {
            // 更新得分
            _model = self.updateScore(exercise: _model)
        }
        // 保存数据到数据库
        self.saveStep(exercise: _model)
        // 更新单词状态
        self.updateProgress(exercise: _model)
    }

    /// 上报关卡
    func report(type: YXExerciseDataType, completion: ((_ result: Bool, _ msg: String?) -> Void)?) {
        let reportContent = self.getReportJson()
        let duration      = self.getLearnDuration()
        YXLog("上报内容：" + reportContent)
        YXLog("学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: type.rawValue, time: duration, result: reportContent)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXWordModel>.self, request: request, success: { (response) in
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
    private func getReportJson() -> String {
        var modelArray = [YXExerciseReportModel]()
        // 获得所有学习的单词单词
        let exerciseModelList = [YXExerciseReportModel]() // 查询所有单词
        exerciseModelList.forEach { (model) in
            var _model = YXExerciseReportModel()
            _model.wordId     = model.wordId
            _model.bookId     = model.bookId
            _model.unitId     = model.unitId
            _model.score      = model.score
            _model.errorCount = model.errorCount
            _model.result     = model.result
            modelArray.append(_model)
        }
        return modelArray.toJson()
    }

    /// 获取学习时长
    private func getLearnDuration() -> Int {
        return 0
    }

}
