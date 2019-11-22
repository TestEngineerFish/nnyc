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

        questionView = YXChineseFillQuestionView(exerciseModel: exerciseModel)
        questionView?.layer.removeShadow()
        self.contentView.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)

        answerView = YXAnswerConnectionLettersView(exerciseModel: exerciseModel)
        self.contentView.addSubview(answerView!)

        answerView?.delegate       = questionView
        answerView?.answerDelegate = self

        self.contentView.layer.setDefaultShadow()
    }
    
    override func layoutSubviews() {
        guard let question = self.exerciseModel.question else {
            return
        }
        let questionH = AdaptSize(100)
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.height.equalTo(questionH)
            make.left.width.equalToSuperview()
        })

        let answerViewTop    = AdaptSize(35)
        let answerViewBottom = AdaptSize(50)
        let itemInterval     = AdaptSize(8)
        let itemSize         = AdaptSize(48)
        let answerViewW = CGFloat(question.column) * (itemInterval + itemSize) - itemInterval
        let answerViewH = CGFloat(question.row) * (itemInterval + itemSize) - itemInterval
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionView!.snp.bottom).offset(answerViewTop)
            make.width.equalTo(answerViewW)
            make.height.equalTo(answerViewH)
        })

        let contentH = questionH + answerViewTop + answerViewH + answerViewBottom
        self.contentView.snp.makeConstraints { (make) in
            make.height.equalTo(contentH)
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.top.equalToSuperview().offset(AdaptSize(32))
        }
        
        remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.bottom).offset(AdaptSize(15))
            make.left.width.equalTo(contentView)
            make.bottom.equalToSuperview().priorityLow()
        })
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
    
}
