//
//  YXNewLearnPrimarySchoolWordGroupExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnPrimarySchoolWordGroupExerciseView: YXBaseExerciseView, YXNewLearnProtocol {

    var guideView = YXNewLearnGuideView()

    var detailView: YXNewLearnJuniorHighSchoolQuestionView?
    var rightContentView: UIView = {
        let view = UIView()
        return view
    }()
    var leftContentView: UIView = {
        let view = UIView()
        return view
    }()
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    override func createSubview() {
        self.addSubview(contentView)
        self.contentView.addSubview(leftContentView)
        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: exerciseModel)
        if exerciseModel.word?.examples?.first?.english != nil {
            (questionView as! YXNewLearnPrimarySchoolQuestionView).showImageView()
            (questionView as! YXNewLearnPrimarySchoolQuestionView).showExample()
        }
        self.leftContentView.addSubview(questionView!)

        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        (answerView as! YXNewLearnAnswerView).newLearnDelegate = self
        answerView?.answerDelegate  = self
        self.leftContentView.addSubview(answerView!)

        detailView = YXNewLearnJuniorHighSchoolQuestionView(exerciseModel: exerciseModel)
        self.contentView.addSubview(rightContentView)
        self.rightContentView.addSubview(detailView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(2)
        }
        leftContentView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
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
        detailView?.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        })
        rightContentView.snp.makeConstraints({ (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(leftContentView.snp.right)
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
        let roundSize  = CGSize(width: AdaptSize(115), height: AdaptSize(115))
        let audioView  = (answerView as! YXNewLearnAnswerView).recordAudioButton
        let audioFrame = audioView.convert(audioView.frame, to: kWindow)
        self.guideView.show(CGRect(x: screenWidth - AdaptSize(108) - roundSize.width/2, y: audioFrame.maxY - AdaptSize(roundSize.height/2), width: roundSize.width, height: roundSize.height))
        YYCache.set(true, forKey: YXLocalKey.alreadShowNewLearnGuideView.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideGuideView))
        self.guideView.addGestureRecognizer(tap)
    }

    @objc private func hideGuideView() {
        self.guideView.removeFromSuperview()
        guard let _answerView = self.answerView as? YXNewLearnAnswerView else {
            return
        }
        _answerView.status.forward()
    }

    func showDetailView() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
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
        if exerciseModel.word?.examples?.first?.english != nil {
            self.exerciseDelegate?.showTipsButton()
        }
        self.exerciseDelegate?.showRightNextView()
    }

    /// 显示新学单词详情
    func showNewLearnWordDetail() {
        self.showDetailView()
        self.exerciseDelegate?.showCenterNextButton()
    }
    
    /// 禁用底部所有按钮
    func disableAllButton() {
        self.exerciseDelegate?.disableAllButton()
    }
    /// 启用底部所有按钮
    func enableAllButton() {
        self.exerciseDelegate?.enableAllButton()
    }
}
