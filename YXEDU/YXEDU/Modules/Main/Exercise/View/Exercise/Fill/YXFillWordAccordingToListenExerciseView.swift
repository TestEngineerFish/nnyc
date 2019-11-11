//
//  YXFillWordAccordingToListenExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音填空
class YXFillWordAccordingToListenExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXListenAndLackWordQuestionView(exerciseModel: exerciseModel)
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
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(180)
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
