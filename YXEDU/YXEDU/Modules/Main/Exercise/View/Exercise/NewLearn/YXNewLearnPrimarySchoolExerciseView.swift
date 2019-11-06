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

    var squirrelImageView = UIImageView()
    var tipsImageView     = UIImageView()

    override func createSubview() {
        super.createSubview()
        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)

        questionView?.delegate     = answerView
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        (questionView as! YXNewLearnPrimarySchoolQuestionView).firstView?.audioView.delegate  = answerView
        (questionView as! YXNewLearnPrimarySchoolQuestionView).secondView?.audioView.delegate = answerView
        (questionView as! YXNewLearnPrimarySchoolQuestionView).thirdView?.audioView.delegate  = answerView
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
        guard let _questionview = questionView as? YXNewLearnPrimarySchoolQuestionView, let currentView = _questionview.currentView else {
            return
        }
        currentView.audioView.clickAudioBtn()
    }

    private func reportAudioData() {

    }

}
