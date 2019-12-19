//
//  YXNewLearnPrimarySchoolExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 小学新学
class YXNewLearnPrimarySchoolExerciseView: YXBaseExerciseView, YXNewLearnProtocol {

    var guideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    override func createSubview() {
        super.createSubview()

        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel)
        (questionView as! YXNewLearnPrimarySchoolQuestionView).showExample()
        self.addSubview(questionView!)
        
        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        (answerView as! YXNewLearnAnswerView).newLearnDelegate = self
        self.addSubview(answerView!)
        answerView?.answerDelegate  = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-44))
            make.bottom.equalTo(answerView!.snp.bottom)
        })

        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(80))
            make.right.equalToSuperview().offset(AdaptSize(-80))
            make.height.equalTo(AdaptSize(145))
        })
    }

    deinit {
        guard let _answerView = answerView else {
            return
        }
        NotificationCenter.default.removeObserver(_answerView)
    }

    // MARK: ==== Event ====
    private func showGuideView() {
        kWindow.addSubview(guideView)
        guideView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideGuideView))
        guideView.addGestureRecognizer(tap)
        YYCache.set(true, forKey: kAlreadShowNewLearnGuideView)
    }

    @objc private func hideGuideView() {
        guideView.removeFromSuperview()
    }

    // MARK: ==== YXAnswerViewDelegate ====

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

    // MARK: ==== YXNewLearnProtocol ===

    /// 单词和例句播放结束
    func playWordAndExampleFinished() {
        guard let question = questionView as? YXNewLearnPrimarySchoolQuestionView else {
            return
        }
        question.showWordView()
    }

    /// 单词和单词播放结束
    func playWordAndWordFinished() {
        if !(YYCache.object(forKey: kAlreadShowNewLearnGuideView) as? Bool ?? false)  {
            print("显示引导图")
            self.showGuideView()
        }
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.status = .showGuideView

    }
}
