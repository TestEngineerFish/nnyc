//
//  YXBaseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/29.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习相关的协议
protocol YXExerciseViewDelegate: NSObjectProtocol {
    /// 普通题型练习完成（不包括连线题）
    /// - Parameter right: 是否答对
    func exerciseCompletion(_ exerciseModel: YXExerciseModel, _ right: Bool)
    /// 隐藏底部右侧视图
    func showTipsButton()
    /// 显示底部右侧视图
    func showRightNextView()
    /// 显示下一步按钮
    func showCenterNextButton()
    /// 禁用底部所有按钮
    func disableAllButton()
    /// 启用底部所有按钮
    func enableAllButton()
    /// 点击提示一下按钮
    func clickTipsBtnEventWithExercise()
}


/// 练习模块基类：内容主页面，包括题目View、答案View、TipsView
class YXBaseExerciseView: UIView, YXAnswerViewDelegate, YXRemindViewProtocol, YXExerciseViewControllerProtocol {

    var exerciseModel: YXExerciseModel

    /// 题目view
    var questionView: YXBaseQuestionView?
    var questionViewHeight: CGFloat = AdaptSize(160) {
        willSet {
            self.questionView?.snp.makeConstraints { (make) in
                make.height.equalTo(newValue)
            }
        }
    }

    // 包括提醒和答案区域
    var scrollView = UIScrollView()

    /// 提醒view
    var remindView: YXRemindView?
    let remindViewDefaultHeight = AdaptSize(isPad() ? 140 : 90)
    var remindViewHeight = AdaptSize(isPad() ? 140 : 90) {
        willSet {
            remindView?.snp.updateConstraints({ (make) in
                make.height.equalTo(newValue)
            })
        }
        didSet {
            self.adjustConstraints()
        }
    }
    
    /// 答案view
    var answerView: YXBaseAnswerView?
    var answerViewHeight: CGFloat {
        return YXExerciseConfig.exerciseViewHeight - questionViewHeight - remindViewDefaultHeight
    }
    
    weak var exerciseDelegate: YXExerciseViewDelegate?
    
    deinit {
        YXLog("练习view 释放")
        YXAVPlayerManager.share.pauseAudio()
    }

    init(exerciseModel: YXExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.createSubview()
        self.bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子类需要设置问题的视图的高度
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func bindData() {}

    func createSubview() {
        self.scrollView.clipsToBounds                  = false
        self.scrollView.isScrollEnabled                = false
        self.scrollView.showsVerticalScrollIndicator   = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        guard let questionView = self.questionView else {
            return
        }
        questionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.width.equalTo(AdaptSize(isPad() ? 660 : 332))
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(questionView.snp.bottom)
            make.left.right.equalTo(questionView)
            make.bottom.equalToSuperview()
        }
        if let remindView = self.remindView, let answerView = answerView {
            remindView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(16))
                make.left.equalToSuperview()
                make.width.equalTo(questionView)
                make.height.equalTo(remindViewDefaultHeight)
            }
            answerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.top.equalTo(remindView.snp.bottom).offset(AdaptSize(10))
                make.width.equalTo(questionView)
                make.centerX.equalTo(self)
            }
        }
    }

    /// 校准scrollView高度
    func adjustConstraints() {
        if self.remindViewHeight > self.remindViewDefaultHeight {
            scrollView.isScrollEnabled = true
        }
    }
    
    /// 动画入场，动画从右边往左边显示出来
    func animateAdmission(_ first: Bool = false, _ completion: (() -> Void)?) {
        
        self.origin.x = screenWidth
        UIView.animate(withDuration: 0.4, delay: first ? 0.4 : 0.2, options: [], animations: { [weak self] in
            guard let self = self else { return }
            self.origin.x = 0
        }) { (finish) in
            if finish {
                completion?()
            }
        }
    }
    
    /// 动画出场
    func animateRemove() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.origin.x = -screenWidth
        }) { [weak self] (finish) in
            if finish {
                self?.removeFromSuperview()
            }
        }
    }
    
    // MARK: ==== YXAnswerViewDelegate ====

    func answerCompletion(exercise model: YXExerciseModel, right: Bool) {
        if model.type == .newLearnMasterList {
            self.exerciseModel.n3List = model.n3List
        }
        self.exerciseModel.status = right ? .right : .wrong
        if !right {
            self.exerciseModel.wrongCount += 1
        }
        self.exerciseDelegate?.exerciseCompletion(self.exerciseModel, right)
    }

    func switchQuestionView() -> Bool { return true }

    // MARK: ==== YXRemindViewProtocol ====
    func updateHeightConstraints(_ height: CGFloat) {}

    // MARK: ==== YXExerciseViewControllerProtocol ====
    func showAlertEvnet() {}
    func backHomeEvent()  {}
    func hideAlertEvent() {}
}
