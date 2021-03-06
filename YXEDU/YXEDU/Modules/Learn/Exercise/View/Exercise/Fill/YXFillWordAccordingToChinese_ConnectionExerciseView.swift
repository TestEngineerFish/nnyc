//
//  YXFillWordAccordingToChinese_ConnectionExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// /// 看中文填空，点击 + 连线两种操作
class YXFillWordAccordingToChinese_ConnectionExerciseView: YXBaseExerciseView {

    var contentView = UIView()

    override func createSubview() {
        self.addSubview(contentView)
        self.contentView.backgroundColor = UIColor.white

        questionView = YXChineseFillConnectionLetterQuestionView(exerciseModel: exerciseModel)
        questionView?.layer.removeShadow()
        self.contentView.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: exerciseModel)
        remindView?.delegate = self
        self.addSubview(remindView!)

        answerView = YXAnswerConnectionLettersView(exerciseModel: exerciseModel)
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        self.contentView.addSubview(answerView!)

        self.contentView.layer.setDefaultShadow()
    }
    
    override func layoutSubviews() {
        guard let question = self.exerciseModel.question, let extend = question.extendModel else {
            return
        }
        let questionH = AdaptIconSize(110)
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.height.equalTo(questionH)
            make.left.width.equalToSuperview()
        })

        let answerViewTop    = AdaptIconSize(35)
        let answerViewBottom = AdaptIconSize(50)
        let answerViewConfit = YXConnectionLettersConfig()
        let answerViewW = CGFloat(extend.column) * (answerViewConfit.itemMargin + answerViewConfit.itemSize.width) - answerViewConfit.itemMargin
        let answerViewH = CGFloat(extend.row) * (answerViewConfit.itemMargin + answerViewConfit.itemSize.height) - answerViewConfit.itemMargin
        if questionView != nil {
            answerView?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(questionView!.snp.bottom).offset(answerViewTop)
                make.width.equalTo(answerViewW)
                make.height.equalTo(answerViewH)
            })
        }

        let contentH = questionH + answerViewTop + answerViewH + answerViewBottom
        self.contentView.snp.makeConstraints { (make) in
            make.height.equalTo(contentH)
            make.left.equalToSuperview().offset(AdaptSize(isPad() ? 54 : 22))
            make.right.equalToSuperview().offset(AdaptSize(isPad() ? -54 : -22))
            make.top.equalToSuperview().offset(AdaptIconSize(32))
        }
        
        remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.bottom).offset(AdaptSize(15))
            make.left.width.equalTo(contentView)
            make.bottom.equalToSuperview().priorityLow()
        })
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord, .image, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }

    override func updateHeightConstraints(_ height: CGFloat) {
        let remindViewH = self.height - self.contentView.frame.maxY
        let lackH = height - remindViewH
        if lackH > 0 {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform(translationX: 0, y: -lackH)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {  [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self = self else { return }
                    self.transform = .identity
                }
                self.remindView?.hideSubviews()
            }
        }
    }
    
}
