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

    var detailView: YXNewLearnJuniorHighSchoolQuestionView?
    var rightContentView: UIView = {
        let view = UIView()
        return view
    }()
    var guideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    override func createSubview() {
        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel)
        if exerciseModel.question?.example != nil {
            (questionView as! YXNewLearnPrimarySchoolQuestionView).showImageView()
            (questionView as! YXNewLearnPrimarySchoolQuestionView).showExample()
        }
        self.addSubview(questionView!)
        
        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        (answerView as! YXNewLearnAnswerView).newLearnDelegate = self
        answerView?.answerDelegate  = self
        self.addSubview(answerView!)

        self.addSubview(rightContentView)
        detailView = YXNewLearnJuniorHighSchoolQuestionView(exerciseModel: exerciseModel)
        self.addSubview(rightContentView)
        self.rightContentView.addSubview(detailView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-44))
            make.bottom.equalTo(answerView!.snp.top)
        })
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(145))
            make.width.equalToSuperview()
        })
        self.rightContentView.snp.makeConstraints({ (make) in
            make.top.bottom.width.equalToSuperview()
            make.left.equalTo(self.snp.right)
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
        YYCache.set(true, forKey: YXLocalKey.alreadShowNewLearnGuideView.rawValue)
    }

    @objc private func hideGuideView() {
        guideView.removeFromSuperview()
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.status.forward()
    }

    func showDetailView() {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
    }

    // MARK: ==== YXAnswerViewDelegate ====

    override func switchQuestionView() -> Bool {
        //显示单词详情

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
        _answerView.playByStatus()
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
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.status = .showGuideView
        if !(YYCache.object(forKey: YXLocalKey.alreadShowNewLearnGuideView.rawValue) as? Bool ?? false)  {
            self.showGuideView()
        } else {
            _answerView.status.forward()
        }
        if exerciseModel.question?.example != nil {
            self.exerciseDelegate?.showTipsButton()
        }
        self.exerciseDelegate?.showNextButton()
    }
}
