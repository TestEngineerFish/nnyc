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
    
    // 基础学习时，必须要传 bookId和unitId，要缓存进度
    public var bookId: Int?
    public var unitId: Int?
    public var planId: Int?
    public var dataType: YXExerciseDataType = .base
    
    // 数据管理器
    public var dataManager: YXExerciseDataManager!
    
    
    // 练习view容器，用于动画切题
    private var exerciseViewArray: [YXBaseExerciseView] = []
    
    // 顶部view
    private var headerView = YXExerciseHeaderView()
    
    // 底部view
    private var bottomView = YXExerciseBottomView()
    
    /// 切题动画
    private var switchAnimation = YXSwitchAnimation()
    
    // Load视图
    private var loadingView: YXExerciseLoadingView?
    
    // 协议
    private weak var delegate: YXExerciseViewControllerProtocol?
    
    /// 哪个单词的提示，仅连线题使用
    private var remindWordId: Int = -1

    /// 是否在请求接口中，用于Loading页面的状态更新
    static var requesting: Bool?
    static var selectWord: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingView?.removeFromSuperview()
    }

    override func handleData(withQuery query: [AnyHashable : Any]!) {
//        let value = (self.query["type"] as? Int) ?? 1
//        self.dataType = YXExerciseDataType(rawValue: value) ?? .normal
//        self.bookId = self.query["book_id"] as? Int ?? 0
//        self.unitId = self.query["unit_id"] as? Int ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadAnimation()
        self.createSubviews()
        self.bindProperty()
        self.initManager()
        self.loadingView?.downloadCompleteBlock = {
            self.startStudy()
        }
        YXGrowingManager.share.startDate = NSDate()
    }
    
    deinit {
        YXLog("练习 VC 释放")
        YYCache.remove(forKey: .learningState)
        YXAVPlayerManager.share.finishedBlock = nil
        YXAVPlayerManager.share.pauseAudio()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    }
    
    private func initManager() {
        dataManager = YXExerciseDataManager()
        
        // 只有基础学习的bookId才是真实bookId，复习的bookId是后端虚构的ID
        if dataType == .base {
            dataManager.bookId = bookId
            dataManager.unitId = unitId
            
            dataManager.progressManager.bookId = bookId
            dataManager.progressManager.unitId = unitId
        }
        
        dataManager.dataType = dataType
        dataManager.progressManager.planId = planId
        dataManager.progressManager.dataType = dataType
                        
        var array: [YXExerciseDataType] = [.base, .aiReview, .planListenReview, .planReview, .wrong]
        array = []
        for type in array {
            dataManager.progressManager.dataType = type
            dataManager.progressManager.completionExercise()
            dataManager.progressManager.completionReport()
        }
        // 如果符合条件，则跳过新学
        if YXConfigure.shared().isSkipNewLearn {
//            dataManager.skipNewWord()
            YXLog("跳过新学流程")
            // 跳过上报新学到GIO
            YYCache.set(true, forKey: .newLearnReportGIO)
        } else {
            YYCache.set(false, forKey: .newLearnReportGIO)
        }
    }
    
    /// 开始学习
    private func startStudy() {
        YXLog("====开始学习====")
        YXExerciseViewController.requesting = true
        // 存在学完未上报的关卡
        if !dataManager.progressManager.isReport() {
            YXLog("本地存在学完未上报的关卡，先加载，再上报")
            // 先加载本地数据
            dataManager.fetchLocalExerciseModels()
            YXExerciseViewController.requesting = false
            // 再上报关卡
            self.report()
        } else if !dataManager.progressManager.isCompletion() && dataManager.fetchLocalExerciseModels() {// 存在未学完的关卡
            YXLog("本地存在未学完的关卡，先加载")
            YXExerciseViewController.requesting = false
            // 开始答题
            self.loadingView?.animationCompleteBlock = { [weak self] in
                self?.dataManager.progressManager.setStartStudyTime()
                self?.switchExerciseView()
            }
        } else {
            self.fetchExerciseData()
        }
        dataManager.progressManager.updateStudyCount()
    }
    
    
    // 加载当天的学习数据
    private func fetchExerciseData() {
        dataManager.fetchTodayExerciseResultModels(type: dataType, planId: planId) { [weak self] (result, msg) in
            guard let self = self else { return }
            if result {
                YXExerciseViewController.requesting = false
                DispatchQueue.main.async {
                    self.loadingView?.animationCompleteBlock = { [weak self] in
                        self?.dataManager.progressManager.setStartStudyTime()
                        self?.switchExerciseView()
                    }
                }
            } else {
                YXExerciseViewController.requesting = false
                UIView.toast("加载数据失败")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 切换题目
    private func switchExerciseView() {
        YXLog("==== 切题 ====")

        let data = dataManager.fetchOneExerciseModel()
        headerView.learningProgress = "\(data.0)"
        headerView.reviewProgress = "\(data.1)"
        
        if var model = data.2 {
            model.dataType = dataType

            YXRequestLog("==== 题目内容：%@", model.toJSONString() ?? "--")

            // 小学新学
            let primaryNewLearnArray: [YXExerciseType] = [.newLearnPrimarySchool_Group, .newLearnPrimarySchool]
            // 新学
            let newLearnArray: [YXExerciseType]        = [.newLearnJuniorHighSchool] + primaryNewLearnArray
            // 新学和连线题
            let hideTipsTypeArray: [YXExerciseType]    = [.validationImageAndWord, .validationWordAndChinese] + newLearnArray
            // ---- 新学、连线题隐藏提示
            self.bottomView.tipsButton.isHidden  = hideTipsTypeArray.contains(model.type)

            // 新学流程是否允许打断
            if self.dataManager.progressManager.ruleType() == .a2 && primaryNewLearnArray.contains(model.type) {
                self.showRightNextView()
            }
            // ---- Growing
            if newLearnArray.contains(model.type) {
                YXGrowingManager.share.newLearnNumber += 1
            } else {
                if !(YYCache.object(forKey: .newLearnReportGIO) as? Bool ?? false) {
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
            
            // 连线未选中时，禁用提示
            let tipsEnabled = !(model.type == .connectionWordAndImage || model.type == .connectionWordAndChinese)
            self.bottomView.tipsButton.isEnabled = tipsEnabled
            // 如果是高中新学，则隐藏底部栏
            var exerciseViewHeight = YXExerciseConfig.exerciseViewHeight
            if model.type == .newLearnJuniorHighSchool {
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
            if !exerciseViewArray.isEmpty {
                YXAVPlayerManager.share.pauseAudio()
                YXAVPlayerManager.share.finishedBlock = nil
            }
            let exerciseView = YXExerciseViewFactory.buildView(exerciseModel: model)
            exerciseView.frame = CGRect(x: screenWidth, y: self.headerView.frame.maxY, width: screenWidth, height: exerciseViewHeight)
            self.delegate = exerciseView
            exerciseView.exerciseDelegate = self
            exerciseView.answerView?.connectionAnswerViewDelegate = self

            loadExerciseView(exerciseView: exerciseView)
        } else {            
            self.report()
        }
    }
    
    /// 加载一个练习
    /// - Parameter exerciseView: 新的练习view
    private func loadExerciseView(exerciseView: YXBaseExerciseView) {
        YXLog("==== 加载练习题 ====")
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
        self.dataManager.progressManager.setOneExerciseFinishStudyTime()
    }
    
    /// 显示loading动画
    private func showLoadAnimation() {
        YXLog("显示学习前加载动画")
        self.loadingView = YXExerciseLoadingView(frame: kWindow.bounds)
        kWindow.addSubview(self.loadingView!)
        self.loadingView?.startAnimation()
    }
    
    private func updateToken() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            YXLog("更新token")
            self?.updateTokenAction()
        }
    }
    
    private func updateTokenAction() {
        YXUserModel.default.updateToken()
    }

    // TODO: ---- Notification ----
    @objc private func didEnterBackground() {
        self.uploadGrowing()
    }

    @objc private func willEnterForeground() {
        YXGrowingManager.share.startDate = NSDate()
    }

    // TODO: ---- Event ----

    private func uploadGrowing() {
        YXGrowingManager.share.uploadLearnStop()
    }

    private func clickTipsBtnEvent() {
        YXLog("点击提示按钮")
        guard let exerciseModel = self.exerciseViewArray.first?.exerciseModel, exerciseModel.word != nil else { return }

        switch exerciseModel.type {
        case .connectionWordAndImage, .connectionWordAndChinese :
            dataManager.connectionAnswerAction(wordId: remindWordId, step: exerciseModel.step, right: false, type: exerciseModel.type)
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
            self.dataManager.normalAnswerAction(exerciseModel: exerciseModel, right: false)
        }

        if exerciseModel.type != .connectionWordAndChinese && exerciseModel.type != .connectionWordAndImage {
            self.exerciseViewArray[0].isWrong = true
        }
        self.exerciseViewArray[0].remindAction(wordId: self.remindWordId, isRemind: true)
        self.exerciseViewArray.first?.remindView?.show()
    }
}
 
extension YXExerciseViewController: YXExerciseViewDelegate {

    func clickTipsBtnEventWithExercise() {
        self.clickTipsBtnEvent()
    }

    ///答完题回调处理， 正常题型处理（不包括连线题）
    /// - Parameter right:
    func exerciseCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
        YXLog("回答" + (right ? "正确" : "错误"))
        // 答题后，数据处理
        self.dataManager.normalAnswerAction(exerciseModel: exerciseModel, right: right)
        
        // 新学直接切题，不用显示动画后
        if exerciseModel.type == .newLearnPrimarySchool
            || exerciseModel.type == .newLearnPrimarySchool_Group
            || exerciseModel.type == .newLearnJuniorHighSchool {
            self.switchExerciseView()
            return
        }
        
        // 如果有做错
        if !right && (exerciseModel.type != .connectionWordAndChinese && exerciseModel.type != .connectionWordAndImage) {
            self.exerciseViewArray.first?.isWrong = true
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
        let e = self.exerciseViewArray.first
        
        let isWrong = e?.isWrong ?? false
        let wordId = e?.exerciseModel.word?.wordId ?? 0
        let step = e?.exerciseModel.step ?? 0
                
        if isWrong || dataManager.isShowWordDetail(wordId: wordId, step: step) {
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

extension YXExerciseViewController: YXConnectionAnswerViewDelegate {
    func connectionViewSelectedStatus(selected: Bool, wordId: Int) {
        bottomView.tipsButton.isEnabled = selected
        if selected {
            remindWordId = wordId
            self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: false)
        }
    }
    
    
    /// 连线题做错后的提示
    /// - Parameter wordId: 那个做错
    func remindEvent(wordId: Int) {
        self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
        self.exerciseViewArray[0].remindView?.show()
    }
    
    
    ///答完题回调处理， 仅连线题处理
    func connectionEvent(wordId: Int, step: Int, right: Bool, type: YXExerciseType, finish: Bool) {
        dataManager.connectionAnswerAction(wordId: wordId, step: step, right: right, type: type)
        
        // 只处理做对的情况，做错进入了 remindEvent方法处理
        if right {// 连线正确
            
            // 当前轮次中是否有错, 有错显示详情页
            if dataManager.hasErrorInCurrentTurn(wordId: wordId, step: step) {
                self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
                                
                if finish {// 这一题全部连线完后要切题
                    dataManager.updateConnectionExerciseFinishStatus(exerciseModel: exerciseViewArray[0].exerciseModel, right: true)
                    self.exerciseViewArray[0].remindView?.remindDetail {// 显示完详情页，再切题
                        self.switchExerciseView()
                    }
                } else { // 没连完，只显示详情页
                    self.exerciseViewArray[0].remindView?.remindDetail()
                }
            } else { // 没有错时
                if finish {// 全部连完，直接切题
                    dataManager.updateConnectionExerciseFinishStatus(exerciseModel: exerciseViewArray[0].exerciseModel, right: true)
                    
                    if dataManager.isShowWordDetail(wordId: wordId, step: step) { // 判断是不是P2类型首次的学习
                        self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
                        self.exerciseViewArray[0].remindView?.remindDetail {
                            self.switchExerciseView()
                        }
                    } else { // 不是P2类型，直接切题
                        self.switchExerciseView()
                    }
                    
                    
                } else if dataManager.isShowWordDetail(wordId: wordId, step: step) {// 没有连完，判断是不是P2类型首次的学习
                    self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
                    self.exerciseViewArray[0].remindView?.remindDetail()
                }
            }
        }
        
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
            self.uploadGrowing()
            self.dataManager.progressManager.setOneExerciseFinishStudyTime()
            
            self.delegate?.backHomeEvent()
            
            self.navigationController?.popToRootViewController(animated: false)
        }
        alertView.cancleClosure = { [weak self] in
            guard let self = self, self == UIView().currentViewController else {
                return
            }
            YXLog("继续学习")
            self.delegate?.hideAlertEvent()
        }
        
        alertView.show()
    }
    
    func clickSwitchBtnEvent() {
        self.delegate?.backHomeEvent()
        self.dataManager.progressManager.completionExercise()
        self.dataManager.progressManager.completionReport()
        self.navigationController?.popViewController(animated: true)
    }
    
    func clickSkipBtnEvent() {
        self.delegate?.backHomeEvent()
        self.dataManager.skipNewWord()
        self.navigationController?.popViewController(animated: true)
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


