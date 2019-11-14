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
        questionView = YXWordAndImage_FillQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(250)
        }
        remindView?.snp.makeConstraints({ (make) in
            make.left.equalTo(questionView!)
            make.top.equalTo(questionView!.snp.bottom)
            make.width.equalTo(questionView!)
            make.height.equalTo(AdaptSize(120))
        })
        let topPadding = self.height - 200
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topPadding)
            make.width.equalTo(270)
            make.height.equalTo(200)
        })
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
}
