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
    var learnConfig: YXLearnConfig   = YXBaseLearnConfig()
    var ruleType: YXExerciseRule     = .p0
    var progress: YXExerciseProgress = .none
    
    var newWordCount: Int { return getNewWordCount() }
    var reviewWordCount: Int { return getReviewWordCount() }
    
    // ----------------------------
    //MARK: - Private 属性
    var _exerciseOptionManange = YXExerciseOptionManager()
    
    var _resultModel: YXExerciseResultModel?
    
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
        
        // 更新当前轮数据（如果做完）
        self.updateCurrentTurn()
        
        // 查找练习
        let model = self._findExercise()
        
        // 打印
        self._printCurrentTurn()
        return model
    }

    func addStudyCount() {
        self.studyDao.addStudyCount(study: _studyId)
    }

    func setStartTime() {
        self.studyDao.setStartTime(study: _studyId)
    }

    func getStartTime(learn config: YXLearnConfig) -> NSDate? {
        let startTimeStr = self.studyDao.getStartTime(learn: config)
        let time = NSDate(string: startTimeStr, format: NSDate.ymdHmsFormat())
        return time
    }

    func getAllWordAmount() -> Int {
        return exerciseDao.getAllWordExerciseAmount(study: _studyId)
    }

    func getNewWordAmount() -> Int {
        return self.exerciseDao.getFinishedNewWordAmount(study: _studyId)
    }

    func getReviewWordAmount() -> Int {
        return self.exerciseDao.getFinishedReviewWordAmount(study: _studyId)
    }

    func updateDurationTime() {
        let currentTime  = Date()
        let startTimeStr = self.studyDao.getStartTime(learn: learnConfig)
        if let startTime = NSDate(string: startTimeStr, format: NSDate.ymdHmsFormat()) {
            let duration = currentTime.timeIntervalSince(startTime as Date)
            self.studyDao.setDurationTime(study: _studyId, duration: Int(duration))
            self.setStartTime()
        }
    }

    func answerAction(exercise: YXExerciseModel, isRemind: Bool = false) {
        if exercise.type == .newLearnMasterList {
            n3AnswerAction(exercise: exercise)
        } else {
            normalAnswerAction(exercise: exercise, isRemind: isRemind)
        }
    }

    private func n3AnswerAction(exercise: YXExerciseModel) {
        for model in exercise.n3List {
            self.normalAnswerAction(exercise: model, isRemind: false)
        }
    }
    
    private func normalAnswerAction(exercise model: YXExerciseModel, isRemind: Bool) {
        if !isRemind {
            // - 更新缓存表
            self.updateCurrentTurn(exercise: model)
        }
        // - 更新Step表
        self.updateStep(exercise: model)
        // - 更新练习表
        self.updateExercise(exercise: model)
        // - 更新学习流程表
        self.updateDurationTime()
    }

    func updateStudyProgress(study id: Int, progress status: YXExerciseProgress) {
        self.studyDao.updateProgress(studyId: id, progress: status)
    }
    
    /// 上报关卡
    func reportReport(completion: ((_ result: YXResultModel?, _ dict: [String:Int]) -> Void)?) {
        let reportContent = self.getReportJson()
        let duration      = self.getLearnDuration()
        YXLog("====上报数据====")
        YXLog("new上报内容：" + reportContent)
        YXLog("new学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: learnConfig.learnType.rawValue, time: duration, result: reportContent)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            var newWordCount    = 0
            var reviewWordCount = 0
            // 获取学习数据
            let duration    = self.studyDao.getDurationTime(learn: self.learnConfig)
            let studyCount  = self.studyDao.selectStudyCount(learn: self.learnConfig)
            newWordCount    = self.exerciseDao.getNewWordExerciseAmount(study: self._studyId)
            reviewWordCount = self.exerciseDao.getReviewWordExerciseAmount(study: self._studyId)
            // 上报Growing
            YXGrowingManager.share.biReport(learn: self.learnConfig, duration: duration, study: studyCount)
            if self.learnConfig.learnType == .base {
                YXGrowingManager.share.uploadLearnFinished()
                // 记录学完一次主流程，用于首页弹出设置提醒弹框
                YYCache.set(true, forKey: "DidFinishMainStudyProgress")
            }

            // 清除数据库对应数据
            self.cleanStudyRecord()
            completion?(response.data, ["newWordCount":newWordCount, "reviewWordCount":reviewWordCount])
        }) { (error) in
            self.studyDao.updateProgress(studyId: self._studyId, progress: .unreport)
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, [:])
        }
    }
    
    func cleanStudyRecord() {                
        if _studyId > 0 {
            let r1 = studyDao.delete(study: _studyId)
            let r2 = exerciseDao.deleteExercise(study: _studyId)
            let r3 = stepDao.deleteStepWithStudy(study: _studyId)
            let r4 = turnDao.deleteCurrentTurn(study: _studyId)
            self.progress = .none
            YXLog("清除学习记录完成 ", learnConfig.desc)
            YXLog("删除当前学习记录 studyId=", _studyId, r1, r2, r3, r4)
        } else {
            YXLog("删除当前学习记录失败, studyId=", _studyId, learnConfig.desc)
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
