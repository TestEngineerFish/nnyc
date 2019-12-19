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


    let contentViewW = screenWidth - AdaptSize(44)

    override func createSubview() {
        super.createSubview()

        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)
//        answerView?.delegate        = firstQuestionView
        answerView?.answerDelegate  = self


        // 延迟播放.(因为在切题的时候会有动画)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
            var isPlay = true
            kWindow.subviews.forEach { (subview) in
                if subview.tag != 0 {
                    isPlay = false
                }
            }
            if isPlay {
                self.playerAudio()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(answerView!.snp.bottom)
        })

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
        questionView?.playAudio()
    }

    // MARK: YXAnswerViewDelegate

    override func switchQuestionView() -> Bool {

        return true
    }

    // MARK: ==== YXExerciseViewControllerProtocol ====
    override func backHomeEvent() {
        super.backHomeEvent()
        // 暂停播放
        YXAVPlayerManager.share.pauseAudio()
        USCRecognizer.sharedManager()?.cancel()
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
