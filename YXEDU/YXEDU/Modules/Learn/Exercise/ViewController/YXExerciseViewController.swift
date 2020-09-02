 //
 //  YXExerciseViewController.swift
 //  YXEDU
 //
 //  Created by sunwu on 2019/10/24.
 //  Copyright © 2019 shiji. All rights reserved.
 //
 
 import UIKit
 protocol YXExerciseViewControllerProtocol: NSObjectProtocol {
    /// 显示弹框事件
    func showAlertEvnet()
    /// 返回首页事件
    func backHomeEvent()
    /// 隐藏弹框事件
    func hideAlertEvent()
 }
 
 /// 练习模块，主控制器
 class YXExerciseViewController: YXViewController {
    
    /// 学习配置
    public var learnConfig: YXLearnConfig = YXBaseLearnConfig()
        
    /// 练习出题逻辑管理器
    var service: YXExerciseService = YXExerciseServiceImpl()
    
    /// 练习view容器，用于动画切题
    private var exerciseViewArray: [YXBaseExerciseView] = []
    
    /// 顶部view
    private var headerView = YXExerciseHeaderView()
    
    /// 底部view
    private var bottomView = YXExerciseBottomView()
    
    /// 切题动画
    private var switchAnimation = YXSwitchAnimation()
    
    /// Load视图
    var loadingView: YXExerciseLoadingView?
    
    /// 协议
    private weak var delegate: YXExerciseViewControllerProtocol?

    /// 是否在请求接口中，用于Loading页面的状态更新
    static var requesting: Bool?
    static var selectWord: Bool?
    /// 是否不允许退出学习
    var isFocusStudy: Bool = false
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingView = nil
        YXWordBookResourceManager.stop = false
        YXAVPlayerManager.share.finishedBlock = nil
        YXAVPlayerManager.share.pauseAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadAnimation()
        self.createSubviews()
        self.bindProperty()
        self.initManager()
        YXGrowingManager.share.startDate = NSDate()
    }
    
    deinit {
        YXLog("练习 VC 释放")
        YYCache.remove(forKey: .learningState)
        YXAVPlayerManager.share.finishedBlock = nil
        YXAVPlayerManager.share.pauseAudio()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func createSubviews() {
        headerView.delegate = self
        bottomView.delegate = self
        self.view.addSubview(headerView)
        self.view.addSubview(bottomView)
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(YXExerciseConfig.headerViewTop)
            make.left.right.equalToSuperview()
            make.height.equalTo(YXExerciseConfig.headerViewHeight)
        }

        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(YXExerciseConfig.exerciseViewBottom)
            make.bottom.equalToSuperview()
        }
        // 学习中不允许返回
        if isFocusStudy {
            self.headerView.focusStudy()
        }
    }
    
    private func bindProperty() {
        self.view.backgroundColor = UIColor.white
        self.customNavigationBar?.isHidden = true
        self.switchAnimation.owenrView = self.view
        self.switchAnimation.animationDidStop = { [weak self] (right) in
            self?.animationDidStop(isRight: right)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadWordError), name: YXNotification.kDownloadWordError, object: nil)
    }
    
    private func initManager() {
        service.learnConfig = self.learnConfig
        service.initService()
        YXExerciseViewController.requesting = true
        YXGrowingManager.share.uploadNewStudy()
        YYCache.set(false, forKey: .newLearnReportGIO)
        let log = String(format: "==== 开始%@学习, 配置信息：%@ ====", self.learnConfig.learnType.desc, self.learnConfig.desc)
        YXLog(log)
    }
    
    /// 开始学习
    func startStudy() {
//        YXExerciseViewController.requesting = false
        // 主流程、打卡作业结果页
//        self.processBaseExerciseResult(newCount: 11, reviewCount: 10)
        // 非主流程
//        self.processReviewResult()
//        return
        YXLog("====开始学习====")
        // 开始学习，停止下载
        YXWordBookResourceManager.stop = true
        switch self.service.progress {
        case .unreport:
            YXLog("本地存在学完未上报的关卡，先加载，再上报")
            YXExerciseViewController.requesting = false
            self.submitResult()
        case .learning:
            YXLog("本地存在未学完的关卡，先加载")
            self.service.setStartTime()
            self.service.addStudyCount()
            YXExerciseViewController.requesting = false
        default:
            YXLog("未开始学习，请求学习数据")
            self.service.setStartTime()
            self.service.addStudyCount()
            self.fetchExerciseData()
        }
    }
    
    // 加载当天的学习数据
    private func fetchExerciseData() {
        service.fetchExerciseResultModels { [weak self] (result, msg, isGenerate) in
            guard let self = self else { return }
            YXExerciseViewController.requesting = false
            if result {
                self.service.initService()
                if !isGenerate {
                    self.switchExerciseView()
                }
            } else {
                YXUtils.showHUD(nil, title: "加载学习数据失败，请稍后再试")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 切换题目
    private func switchExerciseView() {
        YXLog("\n=============\n")
        YXLog("==== 切题 ====")
        // 获取题数据
        let data = service.fetchExerciseModel()
        // - 更新待学习数
        headerView.learningProgress = "\(self.service.newWordCount)"
        headerView.reviewProgress   = "\(self.service.reviewWordCount)"
        YXLog("未新学单词数：" + (headerView.learningProgress ?? ""))
        YXLog("未复习单词数：" + (headerView.reviewProgress ?? ""))
        if var model = data {
            model.learnType = learnConfig.learnType

            YXRequestLog("==== 题目内容：%@", model.toJSONString() ?? "--")
            // 新学
            let newLearnArray: [YXQuestionType]     = [.newLearnPrimarySchool_Group,
                                                       .newLearnPrimarySchool,
                                                       .newLearnJuniorHighSchool,
                                                       .newLearnMasterList]
            // 新学和判断题
            let hideTipsTypeArray: [YXQuestionType] = [.validationImageAndWord, .validationWordAndChinese] + newLearnArray
            // ---- 新学、判断题隐藏提示
            self.bottomView.tipsButton.isHidden     = hideTipsTypeArray.contains(model.type)

            // 新学流程是否允许打断
            if model.operate?.canNextAction == .some(true) && (model.type == .newLearnPrimarySchool || model.type == .newLearnPrimarySchool_Group) {
                self.showRightNextView()
            }
            
            // ---- Growing
            if newLearnArray.contains(model.type) {
                YXGrowingManager.share.newLearnNumber += 1
            } else {
                // 新学完成未上报，则上报Growing
                if YYCache.object(forKey: .newLearnReportGIO) as? Bool == .some(false) {
                    YXGrowingManager.share.uploadNewLearnFinished()
                }
                YXGrowingManager.share.exerciseNumber += 1
            }

            if model.type == .newLearnPrimarySchool || model.type == .newLearnPrimarySchool_Group {
                self.bottomView.tipsButton.setTitle("显示例句中文", for: .normal)
            } else {
                self.bottomView.tipsButton.setTitle("提示一下", for: .normal)
            }
            self.bottomView.layoutSubviews()

            // 如果是高中新学、新学列表，则隐藏底部栏
            var exerciseViewHeight = YXExerciseConfig.exerciseViewHeight
            if model.type == .newLearnJuniorHighSchool || model.type == .newLearnMasterList {
                self.bottomView.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(0)
                    make.bottom.equalToSuperview()
                }
                exerciseViewHeight += YXExerciseConfig.exerciseViewBottom
            } else {
                self.bottomView.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(YXExerciseConfig.exerciseViewBottom)
                    make.bottom.equalToSuperview()
                }
            }
            YXAVPlayerManager.share.finishedBlock = nil
            let exerciseView = YXExerciseViewFactory.buildView(exerciseModel: model)
            exerciseView.frame = CGRect(x: screenWidth, y: self.headerView.frame.maxY, width: screenWidth, height: exerciseViewHeight)
            self.delegate = exerciseView
            exerciseView.exerciseDelegate = self
            loadExerciseView(exerciseView: exerciseView)
        } else {
            self.report()
        }
    }
    
    /// 加载一个练习
    /// - Parameter exerciseView: 新的练习view
    private func loadExerciseView(exerciseView: YXBaseExerciseView) {
        YXLog("==== 加载练习题 ====")
        YXLog(String(format: "==== 当前单词 id：%ld, type：%@，rule：%@", exerciseView.exerciseModel.word?.wordId ?? 0,
                     exerciseView.exerciseModel.type.rawValue, exerciseView.exerciseModel.ruleModel?.toJSONString() ?? ""))
        // 是否第一次进来
        var isFirst = true
        if let ceview = exerciseViewArray.first {
            exerciseViewArray.removeFirst()
            ceview.animateRemove()
            isFirst = false
        }
        
        self.view.addSubview(exerciseView)
        exerciseViewArray.append(exerciseView)
        exerciseView.animateAdmission(isFirst, nil)
        
        YYCache.set(true, forKey: .learningState)
    }
    
    /// 显示loading动画
    func showLoadAnimation() {
        self.loadingView = YXExerciseLoadingView(type: self.learnConfig.learnType)
        self.loadingView?.downloadCompleteDelegate  = self
        self.loadingView?.animationCompleteDelegate = self
        kWindow.addSubview(self.loadingView!)
        self.loadingView?.startAnimation()
    }

    // TODO: ---- Notification ----
    @objc private func didEnterBackground() {
        self.uploadGrowing()
        self.service.updateDurationTime()
    }

    @objc private func willEnterForeground() {
        YXGrowingManager.share.startDate = NSDate()
        self.service.setStartTime()
    }

    @objc private func downloadWordError() {
        self.loadingView?.stopAnimation()
        self.navigationController?.popViewController(animated: false)
        YXUtils.showHUD(nil, title: "下载词书失败，请稍后重试")
    }

    // TODO: ---- Event ----

    private func uploadGrowing() {
        YXGrowingManager.share.uploadLearnStop(learn: learnConfig)
    }

    private func clickTipsBtnEvent() {
        YXLog("点击提示按钮")
        guard var exerciseModel = self.exerciseViewArray.first?.exerciseModel, exerciseModel.word != nil else { return }

        switch exerciseModel.type {
        case .newLearnPrimarySchool, .newLearnPrimarySchool_Group:
            guard let exerciseView = self.exerciseViewArray.first as? YXNewLearnPrimarySchoolExerciseView, let questionView = exerciseView.questionView as? YXNewLearnPrimarySchoolQuestionView else {
                return
            }
            questionView.showChineseExample()
            if questionView.chineseExampleLabel.layer.opacity == 0.0 {
                self.bottomView.tipsButton.setTitle("显示例句中文", for: .normal)
            } else {
                self.bottomView.tipsButton.setTitle("收起例句中文", for: .normal)
            }
        default:
            exerciseModel.status = .wrong
            exerciseModel.wrongCount += 1
            // 修改当前对象
            self.exerciseViewArray.first?.exerciseModel.wrongCount += 1
            self.service.answerAction(exercise: exerciseModel, isRemind: true)
        }
        self.exerciseViewArray.first?.remindView?.show()
        NotificationCenter.default.post(name: YXNotification.kClickTipsButton, object: nil)
    }
}
 
extension YXExerciseViewController: YXExerciseViewDelegate {

    func clickTipsBtnEventWithExercise() {
        self.clickTipsBtnEvent()
    }

    ///答完题回调处理， 正常题型处理
    /// - Parameter right:
    func exerciseCompletion(_ exerciseModel: YXExerciseModel, _ right: Bool) {
        YXLog("=============回答" + (right ? "✅" : "❌"))
        // 答题后，数据处理
        self.service.answerAction(exercise: exerciseModel, isRemind: false)
        
        // 新学直接切题，不用显示动画后
        if exerciseModel.type == .newLearnPrimarySchool
            || exerciseModel.type == .newLearnPrimarySchool_Group
            || exerciseModel.type == .newLearnJuniorHighSchool
            || exerciseModel.type == .newLearnMasterList {
            self.switchExerciseView()
            return
        }
        
        // 答题后的对错动画
        switchAnimation.show(isRight: right)
    }

    /// 启用底部左侧视图
    func showTipsButton() {
        self.bottomView.tipsButton.isHidden = false
    }

    /// 显示底部右侧视图
    func showRightNextView() {
        self.bottomView.nextView.isHidden = false
    }

    /// 显示中间下一步按钮
    func showCenterNextButton() {
        self.bottomView.clickNextView()
    }
    
    /// 动画停止后回调
    /// - Parameter isRight: 对错
    func animationDidStop(isRight: Bool) {
        if isRight {
            answerRight()
        } else {
            answerWrong()
        }
    }
    
    /// 答对处理
    func answerRight() {
        let exerciseView = self.exerciseViewArray.first
        let isWrong      = (exerciseView?.exerciseModel.wrongCount ?? 0) > 0
        let showDetail   = exerciseView?.exerciseModel.operate?.showDetail == .some(true)

        if isWrong || showDetail {
            self.showRemindDetail()
        } else {// 切题
            self.switchExerciseView()
        }
    }
    
    /// 答错处理
    func answerWrong() {
        if self.exerciseViewArray.first?.exerciseModel.type == .validationWordAndChinese
            || self.exerciseViewArray.first?.exerciseModel.type == .validationImageAndWord {
            // 判断题做错了，显示详情页后，直接切题
            self.showRemindDetail()
        } else {
            _ = self.exerciseViewArray.first?.remindView?.show()
        }
    }
    
    
    /// 显示详情页后，延迟切题
    func showRemindDetail() {
        self.exerciseViewArray.first?.remindView?.remindDetail {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                self?.switchExerciseView()
            }
        }
    }
    
    /// 禁用底部所有按钮
    func disableAllButton() {
        self.bottomView.tipsButton.isEnabled              = false
        self.bottomView.tipsButton.layer.opacity          = 0.3
        self.bottomView.nextView.layer.opacity            = 0.3
        self.bottomView.nextView.isUserInteractionEnabled = false
    }
    
    /// 启用底部所有按钮
    func enableAllButton() {
        self.bottomView.tipsButton.isEnabled              = true
        self.bottomView.tipsButton.layer.opacity          = 1.0
        self.bottomView.nextView.layer.opacity            = 1.0
        self.bottomView.nextView.isUserInteractionEnabled = true
    }
}

extension YXExerciseViewController: YXExerciseHeaderViewProtocol {
    func clickHomeBtnEvent() {
        YXLog("学习中点击【回首页】按钮")
        self.delegate?.showAlertEvnet()
        
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "是否放弃本次学习并退出?"
        alertView.backgroundView.isUserInteractionEnabled = false
        alertView.doneClosure = { [weak self] (text: String?) in
            guard let self = self, self == UIView().currentViewController else {
                return
            }
            YXLog("返回首页")
            self.service.updateDurationTime()
            self.uploadGrowing()
            self.delegate?.backHomeEvent()
            if self.learnConfig.learnType.isHomework() {
                self.popTo(targetClass: YXMyClassViewController.classForCoder(), animation: false)
            } else if self.learnConfig.learnType == .wrong {
                self.popTo(targetClass: YXWordListViewController.classForCoder(), animation: false)
            } else {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        alertView.cancleClosure = { [weak self] in
            guard let self = self, self == UIView().currentViewController else {
                return
            }
            YXLog("继续学习")
            self.delegate?.hideAlertEvent()
        }
        
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }
    
    func clickSwitchBtnEvent() {
        self.delegate?.backHomeEvent()
        self.service.cleanStudyRecord(hasNextGroup: false)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func clickSkipBtnEvent() {
        self.delegate?.backHomeEvent()
        self.navigationController?.popToRootViewController(animated: false)
    }
}
 
extension YXExerciseViewController: YXExerciseBottomViewProtocol {

    func clickTipsBtnEventWithBottom() {
        self.clickTipsBtnEvent()
    }

    func clickNextViewEvent() {
        YXLog("新学，查看单词详情")
        // 显示单词详情
        guard let exerciseView = self.exerciseViewArray.first as? YXNewLearnPrimarySchoolExerciseView else {
            return
        }
        exerciseView.showDetailView()
        // 记录积分 +0
    }
    func clickNextButtonEvent() {
        YXLog("新学，点击【下一步】按钮")
        guard let exerciseView = self.exerciseViewArray.first as? YXNewLearnPrimarySchoolExerciseView, let answerView = exerciseView.answerView as? YXNewLearnAnswerView else {
            return
        }
        answerView.answerCompletion(right: true)
    }
}

 extension YXExerciseViewController: YXExerciseAnimationCompleteDelegate, YXExerciseDownloadCompleteDelegate {
    func downloadComplete() {
        YXLog("当前词书下载完成，开始主流程的学习")
        self.startStudy()
    }

    func animationComplete() {
        guard self.navigationController?.topViewController?.classForCoder == YXExerciseViewController.classForCoder(), self.service.progress != .unreport else {
            return
        }
        self.switchExerciseView()
    }
 }


