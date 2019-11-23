 //
//  YXExerciseViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习模块，主控制器
class YXExerciseViewController: UIViewController {
            
    public var bookId: Int = 0
    public var unitId: Int = 0
    
    // 数据管理器
    private var dataManager: YXExerciseDataManager!
    /// 进度管理器
    private var progressManager: YXExcerciseProgressManager!
    
    
    // 练习view容器，用于动画切题
    private var exerciseViewArray: [YXBaseExerciseView] = []
        
    // 顶部view
    private var headerView = YXExerciseHeaderView()
    
    // 底部view
    private var bottomView = YXExerciseBottomView()
    
    /// 切题动画
    private var switchAnimation = YXSwitchAnimation()

    // Load视图
    var loadingView: YXExerciseLoadingView?
        
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
        self.hideLoadAnimation()
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
            make.left.right.equalTo(0)
            make.height.equalTo(28)
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(18)
            make.bottom.equalTo(YXExerciseConfig.bottomViewBottom)
        }

    }
    
    private func createSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(bottomView)
    }
    
    
    private func bindProperty() {
        self.view.backgroundColor = UIColor.white
        
        self.switchAnimation.owenrView = self.view
        self.switchAnimation.animationDidStop = { [weak self] (right) in
            self?.animationDidStop(isRight: right)
        }
        
        self.headerView.backEvent = {[weak self] in
            guard let self = self else { return }
            YXComAlertView.show(.common, in: self.view, info: "提示", content: "是否放弃本次学习并退出", firstBlock: { (obj) in
                // 暂停播放和取消录音监听
                YXAVPlayerManager.share.pauseAudio()
                USCRecognizer.sharedManager()?.cancel()
                self.navigationController?.popViewController(animated: true)
            }) { (obj) in
            }
        }
        self.headerView.switchEvent = {[weak self] in
            self?.progressManager.completionExercise()
            self?.progressManager.completionReport()
            self?.navigationController?.popViewController(animated: true)
        }
                
        self.bottomView.tipsEvent = {[weak self] in
            print("提示点击事件")
            guard let exerciseModel = self?.exerciseViewArray.first?.exerciseModel else { return }
            self?.dataManager.completionExercise(exerciseModel: exerciseModel, right: false)
            self?.exerciseViewArray[0].isWrong = true
            _ = self?.exerciseViewArray.first?.remindView?.show()
        }
        
        self.headerView.skipEvent = { [weak self] in
            self?.dataManager.skipNewWord()
            self?.navigationController?.popViewController(animated: true)
        }

    }
    
    private func initManager() {
        dataManager = YXExerciseDataManager(bookId: bookId, unitId: unitId)
        
        progressManager = YXExcerciseProgressManager()
        progressManager.bookId = self.bookId
        progressManager.unitId = self.unitId
    }
    
    /// 开始学习
    private func startStudy() {
        // 存在学完未上报的关卡
        if !progressManager.isReport() {
            // 先加载本地数据
            dataManager.fetchUnCompletionExerciseModels()
            
            // 先上报关卡
            dataManager.reportUnit {[weak self] (result, msg) in
                guard let self = self else { return }
                if result {
                    self.fetchExerciseData()
                } else {//
                    YXUtils.showHUD(self.view, title: "上报失败")
                }
            }
        } else if !progressManager.isCompletion() {// 存在未学完的关卡
            dataManager.fetchUnCompletionExerciseModels()
            self.switchExerciseView()
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
                    self.switchExerciseView()
                }
            } else {//
                YXUtils.showHUD(self.view, title: "加载数据失败")
            }
        }
    }
    
    /// 切换题目
    private func switchExerciseView() {
        self.hideLoadAnimation()
        
        let data = dataManager.fetchOneExerciseModel()
        
        headerView.learningProgress = "\(data.0)"
        headerView.reviewProgress = "\(data.1)"
        
        if var model = data.2 {
            
//            model.type = .lookImageChooseWord
            
            if model.type == .newLearnPrimarySchool || model.type == .newLearnJuniorHighSchool {
                self.bottomView.tipsButton.isHidden = true
            } else {
                self.bottomView.tipsButton.isHidden = false
            }
            let exerciseView = YXExerciseViewFactory.buildView(exerciseModel: model)
            exerciseView.frame = CGRect(x: screenWidth, y: YXExerciseConfig.exerciseViewTop, width: screenWidth, height: YXExerciseConfig.exerciseViewHeight)
            exerciseView.exerciseDelegate = self
            loadExerciseView(exerciseView: exerciseView)
        } else {
            // 没有数据，就是完成了练习
            progressManager.completionExercise()
            
            // 学完，上报
            dataManager.reportUnit { [weak self] (result, errorMsg) in
                guard let self = self else {return}
                if result {
                    // 上报结束
                    self.progressManager.completionReport()
                    
                    let vc = YXLearningResultViewController()
                    vc.bookId = self.dataManager.bookId
                    vc.unitId = self.dataManager.unitId
                    vc.newLearnAmount = self.dataManager.newWordCount
                    vc.reviewLearnAmount = self.dataManager.reviewWordCount
                    

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

    private func hideLoadAnimation() {
        self.loadingView?.stopAnimation()
        self.loadingView = nil
    }
}

extension YXExerciseViewController: YXExerciseViewDelegate {
    ///答完题回调处理
    /// - Parameter right:
    func exerciseCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
        // 答题后，数据处理
        self.dataManager.completionExercise(exerciseModel: exerciseModel, right: right)

        if right {
            if exerciseModel.type == .newLearnPrimarySchool
                || exerciseModel.type == .newLearnPrimarySchool_Group
                || exerciseModel.type == .newLearnJuniorHighSchool {
                // 新学直接切题，不用显示动画后
                self.switchExerciseView()
            } else {
                switchAnimation.showRightAnimation()
                YXAVPlayerManager.share.playRightAudio()
            }
        } else {
            self.exerciseViewArray.first?.isWrong = true
            switchAnimation.showWrongAnimation()
            YXAVPlayerManager.share.playWrongAudio()
        }
        
        switchAnimation.feedback()
    }
    
    
    func animationDidStop(isRight: Bool) {
        if isRight {
            if self.exerciseViewArray.first?.isWrong ?? false {
                self.exerciseViewArray.first?.remindView?.remindDetail()
            }
            // 切题
            self.switchExerciseView()
        } else if self.exerciseViewArray.first?.exerciseModel.type == .validationWordAndChinese
            || self.exerciseViewArray.first?.exerciseModel.type == .validationImageAndWord {
            // 判断题做错了，显示详情页后，直接切题
            self.exerciseViewArray.first?.remindView?.show()
            self.switchExerciseView()
        } else {
            _ = self.exerciseViewArray.first?.remindView?.show()
        }
    }
}
