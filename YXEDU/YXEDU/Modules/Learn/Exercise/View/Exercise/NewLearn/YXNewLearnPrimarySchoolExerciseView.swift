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

    var guideView = YXNewLearnGuideView()
    var isLearned = false
    var detailView: YXWordDetailCommonView?
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
        if !(exerciseModel.word?.examples?.first?.english?.isEmpty ?? true) && (exerciseModel.word?.imageUrl != nil), let _questionView = questionView as? YXNewLearnPrimarySchoolQuestionView {
            _questionView.showImageView()
            _questionView.showExample()
        }
        self.leftContentView.addSubview(questionView!)
        
        answerView = YXNewLearnAnswerView(wordModel: nil, exerciseModel: self.exerciseModel)
        (answerView as! YXNewLearnAnswerView).newLearnDelegate = self
        answerView?.answerDelegate  = self
        self.leftContentView.addSubview(answerView!)
        if let wordModel = exerciseModel.word {
            detailView = YXWordDetailCommonView(frame: CGRect.zero, word: wordModel)
            detailView?.collectionButton.isHidden = true
            detailView?.feedbackButton.isHidden   = true
            self.contentView.addSubview(rightContentView)
            self.rightContentView.addSubview(detailView!)
        }
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
        if answerView != nil {
            questionView?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(AdaptSize(-44))
                make.bottom.equalTo(answerView!.snp.top)
            })
        }
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-65))
            make.height.equalTo(AdaptSize(isPad() ? 160 : 111))
            make.width.equalToSuperview().offset(AdaptSize(isPad() ? -150 : 0))
        })
        detailView?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().priorityLow()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        })
        if rightContentView.superview != nil {
            rightContentView.snp.makeConstraints({ (make) in
                make.top.bottom.right.equalToSuperview()
                make.left.equalTo(leftContentView.snp.right)
            })
        }
    }

    deinit {
        guard let _answerView = answerView else {
            return
        }
        NotificationCenter.default.removeObserver(_answerView)
        self.hideGuideView()
    }

    // MARK: ==== Event ====
    private func showGuideView() {
        let roundSize  = CGSize(width: AdaptSize(115), height: AdaptSize(115))
        let audioView  = (answerView as! YXNewLearnAnswerView).recordAudioButton
        let audioFrame = audioView.convert(audioView.frame, to: kWindow)
        let guideFrame: CGRect = {
            if isPad() {
                return CGRect(x: audioView.frame.midX - roundSize.width/2 + AdaptSize(75), y: audioFrame.midY - roundSize.height + AdaptSize(18), width: roundSize.width, height: roundSize.height)
            } else {
                return CGRect(x: screenWidth - AdaptSize(108) - roundSize.width/2, y: audioFrame.midY - roundSize.height/2 - AdaptSize(10), width: roundSize.width, height: roundSize.height)
            }
        }()
        self.guideView.show(guideFrame)
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
        // 防止将要弹出学习结果页时切题
        if let _answerView = self.answerView as? YXNewLearnAnswerView {
            _answerView.learnResultView.isHidden = true
        }
        self.isLearned = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }) { [weak self] (finished) in
            if finished, let _answerView = self?.answerView as? YXNewLearnAnswerView {
                _answerView.status = .alreadLearn
            }
        }
    }

    // MARK: ==== YXAnswerViewDelegate ====

    override func switchQuestionView() -> Bool {
        return true
    }

    // MARK: ==== YXExerciseViewControllerProtocol ====
    override func backHomeEvent() {
        super.backHomeEvent()
        if let _answerView = answerView as? YXNewLearnAnswerView {
            _answerView.pauseView()
        }
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
        _answerView.startView()
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
        if !self.isLearned {
            if exerciseModel.word?.examples?.first?.english != nil {
                self.exerciseDelegate?.showTipsButton()
            }
            self.exerciseDelegate?.showRightNextView()
        }
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
