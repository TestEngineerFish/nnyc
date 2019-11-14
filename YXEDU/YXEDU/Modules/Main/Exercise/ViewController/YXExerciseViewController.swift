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
    
    
    // 数据管理器
    var dataManager: YXExerciseDataManager = YXExerciseDataManager()
    
    /// 学习进度管理器
//    var progressManager: YXExcerciseProgressManager = YXExcerciseProgressManager()
    
    // 练习view容器，用于动画切题
    private var exerciseViewArray: [YXBaseExerciseView] = []
        
    // 顶部view
    private var headerView: YXExerciseHeaderView = YXExerciseHeaderView()
    
    // 底部view
    private var bottomView: YXExerciseBottomView = YXExerciseBottomView()

    private var resultView = UIImageView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSubviews()
        self.bindProperty()
        self.startStudy()
    }

    deinit {
        self.resultView.removeAllSubviews()
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

        self.resultView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
    }
    
    private func createSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(bottomView)
        kWindow.addSubview(resultView)
        self.resultView.isHidden = true
    }
    
    
    private func bindProperty() {
        self.view.backgroundColor = UIColor.white
        
        self.headerView.backEvent = {[weak self] in
            // 暂停播放和取消录音监听
            YXAVPlayerManager.share.pauseAudio()
            USCRecognizer.sharedManager()?.cancel()
            self?.navigationController?.popViewController(animated: true)
        }
        self.headerView.switchEvent = {[weak self] in
            self?.switchExerciseView()
        }
                
        self.bottomView.tipsEvent = {[weak self] in
            print("提示点击事件")
            self?.exerciseViewArray.first?.remindView?.show()
        }

    }
    
    
    /// 开始学习
    private func startStudy() {
        // 存在学完未上报的关卡
        if YXExcerciseProgressManager.isExistUnReport() {
            // 先上报关卡
            dataManager.reportUnit(test: "") {[weak self] (result, msg) in
                guard let self = self else { return }
                if result {
                    self.fetchExerciseData()
                } else {//
                    YXUtils.showHUD(self.view, title: "上报失败")
                }
            }
        } else if YXExcerciseProgressManager.isExistUnCompletion() {// 存在未学完的关卡
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
        // 当前关卡是否学完
        if YXExcerciseProgressManager.isCompletion() {
            print("显示打卡页面")
            return
        }
        
        if let model = dataManager.fetchOneExerciseModel() {
            if model.type == .newLearnPrimarySchool {
                self.bottomView.tipsButton.isHidden = true
            } else {
                self.bottomView.tipsButton.isHidden = false
            }
            let exerciseView = YXExerciseViewFactory.buildView(exerciseModel: model)
            exerciseView.frame = CGRect(x: screenWidth, y: YXExerciseConfig.exerciseViewTop, width: screenWidth, height: YXExerciseConfig.exerciseViewHeight)
            exerciseView.exerciseDelegate = self
            loadExerciseView(exerciseView: exerciseView)
        } else {
            
            print("学完")
            self.navigationController?.popViewController(animated: true)
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
}


extension YXExerciseViewController: YXExerciseViewDelegate, CAAnimationDelegate {
    ///答完题回调处理
    /// - Parameter right:
    func exerciseCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
        // 这题做完，需要移除掉
        self.dataManager.completionExercise(exerciseModel: exerciseModel, right: right)
        // 更新学习进度
        YXExcerciseProgressManager.updateProgress(exerciseModel: exerciseModel)
        if right {
            self.showRightAnimation()
            YXAVPlayerManager.share.playRightAudio()
        } else {
            self.showWrongAnimation()
            YXAVPlayerManager.share.playWrongAudio()
            
            self.exerciseViewArray.first?.isWrong = true
            // 等待错误提示音播放完后，再进行提示
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                self?.exerciseViewArray.first?.remindView?.show()
            }
        }
        // 震动效果
        if #available(iOS 10.0, *) {
            let shock = UIImpactFeedbackGenerator(style: .medium)
            shock.impactOccurred()
        }
    }

    /// 显示正确动画
    private func showRightAnimation() {
        self.view.isUserInteractionEnabled = false
        self.resultView.isHidden = false
        self.resultView.image = UIImage(named: "success")
        let animation = YXExerciseAnimation.zoomInHideAnimation()
        animation.delegate = self
        animation.setValue(true, forKey: "isRight")
        self.resultView.layer.add(animation, forKey: nil)
    }

    /// 显示错误动画
    private func showWrongAnimation() {
        self.view.isUserInteractionEnabled = false
        self.resultView.isHidden = false
        self.resultView.image = UIImage(named: "error")
        let animation = YXExerciseAnimation.zoomInHideAnimation()
        animation.delegate = self
        animation.setValue(false, forKey: "isRight")
        self.resultView.layer.add(animation, forKey: nil)
    }

    // TODO: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.resultView.isHidden = true
        self.view.isUserInteractionEnabled = true
        self.resultView.layer.removeAllAnimations()
        if let isRight = anim.value(forKey: "isRight") as? Bool, isRight{
            if self.exerciseViewArray.first?.isWrong ?? false {
                self.exerciseViewArray.first?.remindView?.remindDetail()
            }
            // 切题
            self.switchExerciseView()
            
        }
    }
}
