//
//  YXFillWordAccordingToImageExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 看图片填空
class YXFillWordAccordingToImageExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXWordAndImageQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        questionView?.delegate     = answerView
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(37)
            make.height.equalTo(230)
            make.width.equalToSuperview().offset(-44)
        }
        let topPadding = self.height - 200
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topPadding)
            make.width.equalTo(270)
            make.height.equalTo(200)
        })
    }
}
