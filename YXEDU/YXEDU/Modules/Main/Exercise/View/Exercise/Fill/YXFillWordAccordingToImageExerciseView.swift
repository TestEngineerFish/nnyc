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
        self.scrollView.addSubview(remindView!)

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(answerView!)

        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        super.createSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(230)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
}
