//
//  YXNewLearnPrimarySchoolExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 小学新学
class YXNewLearnPrimarySchoolExerciseView: YXBaseExerciseView {

    var firstQuestionView: YXNewLearnPrimarySchoolQuestionView?
    var secondQuestionView: YXNewLearnPrimarySchoolQuestionView?
    var thirdQuestionView: YXNewLearnPrimarySchoolQuestionView?
    var currentQuestionView: YXNewLearnPrimarySchoolQuestionView?

    var contentView = UIScrollView()
    let contentViewW = screenWidth - AdaptSize(44)

    override func createSubview() {
        super.createSubview()
        self.addSubview(contentView)

        firstQuestionView  = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .imageAndAudio)
        secondQuestionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .wordAndAudio)
        thirdQuestionView  = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .wordAndImageAndAudio)
        self.contentView.addSubview(firstQuestionView!)
        self.contentView.addSubview(secondQuestionView!)
        self.contentView.addSubview(thirdQuestionView!)
        self.currentQuestionView = firstQuestionView

        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)

        answerView?.delegate        = firstQuestionView
        answerView?.answerDelegate  = self

        firstQuestionView?.audioPlayerView?.delegate = answerView

        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            self.playerAudio()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: AdaptSize(22), y: AdaptSize(37), width: contentViewW, height: AdaptSize(250))

        firstQuestionView?.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(250))
            make.width.equalTo(contentViewW)
        })

        secondQuestionView?.snp.makeConstraints({ (make) in
            make.left.equalTo(firstQuestionView!.snp.right)
            make.top.equalToSuperview()
            make.width.height.equalTo(firstQuestionView!)
        })

        thirdQuestionView?.snp.makeConstraints({ (make) in
            make.left.equalTo(secondQuestionView!.snp.right)
            make.top.equalToSuperview()
            make.width.height.equalTo(firstQuestionView!)
        })

        contentView.contentSize = CGSize(width: contentViewW*3, height: AdaptSize(250))

        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-44))
            make.height.equalTo(AdaptSize(200))
        })
    }

    deinit {
        guard let _answerView = answerView else {
            return
        }
        NotificationCenter.default.removeObserver(_answerView)
    }

    /// 播放音频
    private func playerAudio() {
        guard let currentQuestionView = currentQuestionView else {
            return
        }
        currentQuestionView.playAudio()
    }

    // MARK: YXAnswerViewDelegate

    override func switchQuestionView() -> Bool {
        guard let currentQuestionView = self.currentQuestionView else {
            return false
        }
        var offsetX = CGFloat.zero
        switch currentQuestionView {
        case firstQuestionView:
            offsetX = contentViewW * 1
            // 更新当前视图
            self.currentQuestionView = secondQuestionView
            // 重新指定Delegate
            secondQuestionView?.audioPlayerView?.delegate = answerView
            answerView?.delegate = secondQuestionView
        case secondQuestionView:
            offsetX = contentViewW * 2
            // 更新当前视图
            self.currentQuestionView = thirdQuestionView
            // 重新指定Delegate
            thirdQuestionView?.audioPlayerView?.delegate = answerView
            answerView?.delegate = thirdQuestionView
        case thirdQuestionView:
            return false
        default:
            break
        }
        self.contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        if let _answerView = answerView as? YXNewLearnAnswerView {
            _answerView.alreadyCount = 0
        }
        return true
    }

    // MARK: ==== YXExerciseViewControllerProtocol ====
    override func backHomeEvent() {
        super.backHomeEvent()
        // 暂停播放
        YXAVPlayerManager.share.pauseAudio()
    }

    override func showAlertEvnet() {
        super.showAlertEvnet()
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.pauseView()
    }

    override func hideAlertEvent() {
        super.hideAlertEvent()
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.playView()
    }

}
