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

    override func createSubview() {
        super.createSubview()
        firstQuestionView  = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .imageAndAudio)
        secondQuestionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .wordAndAudio)
        thirdQuestionView  = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel, type: .wordAndImageAndAudio)
        self.addSubview(firstQuestionView!)
        self.addSubview(secondQuestionView!)
        self.addSubview(thirdQuestionView!)
        self.currentQuestionView = firstQuestionView

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)

        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)

        firstQuestionView?.delegate = answerView
        answerView?.delegate        = firstQuestionView
        answerView?.answerDelegate  = self

//        (questionView as! YXNewLearnPrimarySchoolQuestionView).firstView?.audioView.delegate  = answerView
//        (questionView as! YXNewLearnPrimarySchoolQuestionView).secondView?.audioView.delegate = answerView
//        (questionView as! YXNewLearnPrimarySchoolQuestionView).thirdView?.audioView.delegate  = answerView
        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.playerAudio()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(37))
            make.height.equalTo(AdaptSize(250))
            make.width.equalToSuperview().offset(AdaptSize(-44))
        })
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-44))
            make.height.equalTo(AdaptSize(200))
        })
    }

    private func playerAudio() {
        guard let currentQuestionView = currentQuestionView else {
            return
        }
        currentQuestionView.audioView.clickAudioBtn()
    }

    private func reportAudioData() {

    }

    /// 切换问题
//    override func switchQuestion() {
//        super.switchQuestion()
//        guard let currentView = self.currentView else {
//            return
//        }
//        var offsetX = CGFloat.zero
//        switch currentView {
//        case firstView:
//            offsetX = -self.width * 1
//            if let view = secondView {
//                view.audioView.clickAudioBtn()
//            }
//        case secondView:
//            offsetX = -self.width * 2
//            if let view = thirdView {
//                view.audioView.clickAudioBtn()
//            }
//        default:
//            return
//        }
//        UIView.animate(withDuration: 0.25) {
//            self.contentView.transform = CGAffineTransform(translationX: offsetX, y: 0)
//        }
//    }

}
