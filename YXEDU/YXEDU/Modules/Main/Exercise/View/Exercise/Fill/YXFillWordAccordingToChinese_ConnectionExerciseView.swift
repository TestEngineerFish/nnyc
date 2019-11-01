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

    override func createSubview() {
        questionView = YXChineseQuestionView(exerciseModel: exerciseModel)
        questionView?.layer.removeShadow()
        self.addSubview(questionView!)

        answerView = YXAnswerConnectionLettersView(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        questionView?.delegate     = answerView
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self

        self.layer.setDefaultShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let questionH   = 160
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(questionH)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        })

        let answerViewTop    = 35
        let answerViewBottom = 50
        let answerViewW = self.exerciseModel.matix * (8 + 48) - 8
        let answerViewH = self.exerciseModel.matix * (8 + 48) - 8
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionView!.snp.bottom).offset(35)
            make.width.equalTo(answerViewW)
            make.height.equalTo(answerViewH)
        })

        let viewW = screenWidth - 44
        let viewH = questionH + answerViewTop + answerViewH + answerViewBottom
        self.snp.makeConstraints { (make) in
            make.height.equalTo(viewH)
            make.width.equalTo(viewW)
            make.center.equalToSuperview()
        }

    }
    
}
