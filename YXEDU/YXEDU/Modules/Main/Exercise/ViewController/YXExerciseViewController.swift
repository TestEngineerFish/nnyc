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
 class YXExerciseViewController: UIViewController {
    
    public var bookId: Int = 0
    public var unitId: Int = 0
    
    // 数据管理器
    private var dataManager: YXExerciseDataManager!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideLoadAnimation(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoadAnimation()
        self.createSubviews()
        self.bindProperty()
        self.initManager()
        self.startStudy()
    }
    
    deinit {
        print("练习 VC 释放")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(YXExerciseConfig.headerViewTop)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(28))
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(18))
            make.bottom.equalTo(YXExerciseConfig.bottomViewBottom)
        }
        
    }
    
    private func createSubviews() {
        headerView.delegate = self
        bottomView.delegate = self
        self.view.addSubview(headerView)
        self.view.addSubview(bottomView)
    }
    
    private func bindProperty() {
        self.view.backgroundColor = UIColor.white
        
        self.switchAnimation.owenrView = self.view
        self.switchAnimation.animationDidStop = { [weak self] (right) in
            self?.animationDidStop(isRight: right)
        }
    }
    
    private func initManager() {
        dataManager = YXExerciseDataManager(bookId: bookId, unitId: unitId)
    }
    
    /// 开始学习
    private func startStudy() {
        // 存在学完未上报的关卡
        if !dataManager.progressManager.isReport() {
            // 先加载本地数据
            dataManager.fetchLocalExerciseModels()
            
            // 先上报关卡
            dataManager.reportUnit {[weak self] (result, msg) in
                guard let self = self else { return }
                if result {
                    self.fetchExerciseData()
                } else {//
                    YXUtils.showHUD(self.view, title: "上报失败")
                }
            }
        } else if !dataManager.progressManager.isCompletion() {// 存在未学完的关卡
            dataManager.fetchLocalExerciseModels()
            self.hideLoadAnimation { [weak self] in
                self?.switchExerciseView()
            }
        } else {
            self.fetchExerciseData()
        }
        
    }
    
    
    // 加载当天的学习数据
    private func fetchExerciseData() {
        dataManager.fetchTodayExerciseResultModels { [weak self] (result, msg) in
            guard let self = self else { return }
            if result {
                DispatchQueue.main.async {
                    self.hideLoadAnimation { [weak self] in
                        self?.switchExerciseView()
                    }
                }
            } else {//
                YXUtils.showHUD(self.view, title: "加载数据失败")
            }
        }
    }
    
    /// 切换题目
    private func switchExerciseView() {
        
        let data = dataManager.fetchOneExerciseModel()
        
        headerView.learningProgress = "\(data.0)"
        headerView.reviewProgress = "\(data.1)"
        
        if var model = data.2 {
//            model.type = .lookWordChooseChinese
            
            // 新学隐藏提示
            let tipsHidden = (model.type == .newLearnPrimarySchool || model.type == .newLearnPrimarySchool_Group || model.type == .newLearnJuniorHighSchool || model.type == .validationImageAndWord || model.type == .validationWordAndChinese)
            self.bottomView.tipsButton.isHidden = tipsHidden
            
            // 连线未选中时，禁用提示
            let tipsEnabled = !(model.type == .connectionWordAndImage || model.type == .connectionWordAndChinese)
            self.bottomView.tipsButton.isEnabled = tipsEnabled
                                    
            let exerciseView = YXExerciseViewFactory.buildView(exerciseModel: model)
            exerciseView.frame = CGRect(x: screenWidth, y: self.headerView.frame.maxY, width: screenWidth, height: YXExerciseConfig.exerciseViewHeight)
            self.delegate = exerciseView
            exerciseView.exerciseDelegate = self
            exerciseView.answerView?.connectionAnswerViewDelegate = self
            loadExerciseView(exerciseView: exerciseView)
        } else {
            // 没有数据，就是完成了练习
            dataManager.progressManager.completionExercise()
            
            // 学完，上报
            dataManager.reportUnit { [weak self] (result, errorMsg) in
                guard let self = self else {return}
                if result {
                    let progress = self.dataManager.progressManager.loadLocalWordsProgress()
                    // 上报结束, 清空数据
                    self.dataManager.progressManager.completionReport()
                    
                    let vc = YXLearningResultViewController()
                    vc.bookId = self.dataManager.bookId
                    vc.unitId = self.dataManager.unitId
                    vc.newLearnAmount = progress.0.count
                    vc.reviewLearnAmount = progress.1.count
                                        
                    self.navigationController?.popViewController(animated: false)
                    vc.hidesBottomBarWhenPushed = true
                    YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)                              
                } else {
                    YXUtils.showHUD(self.view, title: "上报关卡失败")
                    self.navigationController?.popViewController(animated: true)
                }
                print("学完")
            }
            
            
        }
        
    }
    
    /// 加载一个练习
    /// - Parameter exerciseView: 新的练习view
    private func loadExerciseView(exerciseView: YXBaseExerciseView) {
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
        
    }
    
    /// 显示loading动画
    private func showLoadAnimation() {
        self.loadingView = YXExerciseLoadingView(frame: kWindow.bounds)
        kWindow.addSubview(self.loadingView!)
        self.loadingView?.showAnimation()
    }
    
    private func hideLoadAnimation(_ completeBlock: (()->Void)?) {
        self.loadingView?.stopAnimation(completeBlock)
        self.loadingView = nil
    }
}
 
extension YXExerciseViewController: YXExerciseViewDelegate {
    
    ///答完题回调处理
    /// - Parameter right:
    func exerciseCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
        // 答题后，数据处理
        self.dataManager.defaultAnswerAction(exerciseModel: exerciseModel, right: right)
        
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
        if self.exerciseViewArray.first?.isWrong ?? false {
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
    
}


extension YXExerciseViewController: YXConnectionAnswerViewDelegate {
    func connectionViewSelectedStatus(selected: Bool, wordId: Int) {
        bottomView.tipsButton.isEnabled = selected
        if selected {
            remindWordId = wordId
            self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: false)
        }
    }
    
    func remindEvent(wordId: Int) {
//        self.exerciseViewArray[0].isWrong = true
        self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
        self.exerciseViewArray[0].remindView?.show()
    }
    
    func connectionEvent(wordId: Int, step: Int, right: Bool, type: YXExerciseType) {
        dataManager.connectionAnswerAction(wordId: wordId, step: step, right: right, type: type)
        
        if right {
            if dataManager.hasConnectionError(wordId: wordId, step: step) {
                self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
                self.exerciseViewArray[0].remindView?.remindDetail()
            }
        }
        
        // 下面有代码调用，重复调了
//        else {// 连错
////            self.exerciseViewArray[0].isWrong = true
//            self.exerciseViewArray[0].remindAction(wordId: wordId, isRemind: true)
//            self.exerciseViewArray[0].remindView?.show()
//        }
        
    }
    
}
 
extension YXExerciseViewController: YXExerciseHeaderViewProtocol {
    func clickHomeBtnEvent() {
        self.delegate?.showAlertEvnet()
        
        let alertView = YXAlertView()
        alertView.descriptionLabel.text = "是否放弃本次学习并退出?"
        alertView.doneClosure = { _ in
            self.delegate?.backHomeEvent()
            self.navigationController?.popViewController(animated: true)
        }
        alertView.cancleClosure = {
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
    func clickTipsBtnEvent() {
        print("提示点击事件")
        guard let exerciseModel = self.exerciseViewArray.first?.exerciseModel, exerciseModel.word != nil else { return }
                
        if exerciseModel.type == .connectionWordAndImage || exerciseModel.type == .connectionWordAndChinese {
            dataManager.connectionAnswerAction(wordId: remindWordId, step: exerciseModel.step, right: false, type: exerciseModel.type)
        } else {
            self.dataManager.defaultAnswerAction(exerciseModel: exerciseModel, right: false)
        }
        
        if exerciseModel.type != .connectionWordAndChinese && exerciseModel.type != .connectionWordAndImage {
            self.exerciseViewArray[0].isWrong = true
        }
        self.exerciseViewArray[0].remindAction(wordId: self.remindWordId, isRemind: true)
        self.exerciseViewArray.first?.remindView?.show()
    }
}
 
