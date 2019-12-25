//
//  YXFillWordAccordingChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// /// 看中文填空，仅点击操作
class YXFillWordAccordingToChineseExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXChineseFillQuestionView(exerciseModel: exerciseModel)
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
        self.questionViewHeight = AdaptSize(160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord, .image, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
}
