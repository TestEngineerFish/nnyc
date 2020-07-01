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
    func fetchExerciseResultModels(completion: ((_ result: Bool, _ msg: String?, _ isGenerate: Bool) -> Void)?) {
        let reviewId = learnConfig.learnType.isHomework() ? learnConfig.homeworkId : learnConfig.planId
        let isGenerate = self.studyDao.selectStudyRecordModel(learn: learnConfig) == nil ? true : false
        let request = YXExerciseRequest.exercise(isGenerate: isGenerate, type: learnConfig.learnType.rawValue, reviewId: reviewId)
        request.execute(YXExerciseResultModel.self, success: { [weak self] (model) in
            self?._resultModel = model
            YXGrowingManager.share.uploadExerciseType(model?.rule ?? "")
            self?._processData {
                completion?(true, nil, isGenerate)
            }
        }) { (msg) in
            YXUtils.showHUD(kWindow, title: msg)
            completion?(false, msg, isGenerate)
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
        // 兼容后台返回错误题型
        if model?.type == .some(.none) {
            if var exerciseModel = model {
                exerciseModel.status = .right
                self.answerAction(exercise: exerciseModel)
                return self._findExercise()
            }
        }
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

    func updateDurationTime() {
        let currentTime  = Date()
        let startTimeStr = self.studyDao.getStartTime(learn: learnConfig)
        if let startTime = NSDate(string: startTimeStr, format: NSDate.ymdHmsFormat()) {
            let duration = currentTime.timeIntervalSince(startTime as Date)
            self.studyDao.setDurationTime(study: _studyId, duration: Int(duration))
            self.setStartTime()
        }
    }

    /// 减少未学数量
    /// - Parameter isNewWord: 是否是新学单词
    func reduceUnlearnedCountWithStudy(isNewWord: Bool) {
        if isNewWord {
            self.studyDao.reduceUnlearnedNewWordCount(study: _studyId)
        } else {
            self.studyDao.reduceUnlearnedReviewWordCount(study: _studyId)
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
        let stepEnd = self.updateExercise(exercise: model)
        // - 更新学习流程表
        self.updateDurationTime()
        if stepEnd {
            self.reduceUnlearnedCountWithStudy(isNewWord: model.word?.wordType == .some(.newWord))
        }
    }

    func updateStudyProgress(study id: Int, progress status: YXExerciseProgress) {
        self.studyDao.updateProgress(study: id, progress: status)
    }
    
    /// 上报关卡
    func reportReport(completion: ((_ result: YXResultModel?, _ dict: [String:Int]) -> Void)?) {
        let reportContent = self.getReportJson()
        let duration      = self.getLearnDuration()
        YXLog("====上报数据====")
        YXLog("new上报内容：" + reportContent)
        YXLog("new学习时长：\(duration)")
        let request = YXExerciseRequest.report(type: learnConfig.learnType.rawValue, reviewId: learnConfig.planId, time: duration, result: reportContent)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            // 获取学习数据
            let duration    = self.studyDao.getDurationTime(learn: self.learnConfig)
            let studyCount  = self.studyDao.selectStudyCount(learn: self.learnConfig)
            let newWordCount    = self.studyDao.getNewWordCount(study: self._studyId)
            let reviewWordCount = self.studyDao.getReviewWordCount(study: self._studyId)
            // 上报Growing
            YXGrowingManager.share.biReport(learn: self.learnConfig, duration: duration, study: studyCount)
            if self.learnConfig.learnType == .base {
                YXGrowingManager.share.uploadLearnFinished()
                // 记录学完一次主流程，用于首页弹出设置提醒弹框
                YYCache.set(true, forKey: "DidFinishMainStudyProgress")
            }
            // 清除数据库对应数据
            self.cleanStudyRecord(hasNextGroup: response.data?.hasNextGroup ?? false)
            self._loadStudyRecord()
            completion?(response.data, ["newWordCount":newWordCount, "reviewWordCount":reviewWordCount])
        }) { (error) in
            // 容错处理
            if reportContent == "[]" {
                self.cleanStudyRecord()
            }
            self.studyDao.updateProgress(study: self._studyId, progress: .unreport)
            YXUtils.showHUD(kWindow, title: error.message)
            completion?(nil, [:])
        }
    }
    
    func cleanStudyRecord(hasNextGroup: Bool = false) {
        if _studyId > 0 {
            var r1 = false
            if hasNextGroup {
                r1 = studyDao.reset(study: _studyId)
            } else {
                r1 = studyDao.delete(study: _studyId)
            }
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
