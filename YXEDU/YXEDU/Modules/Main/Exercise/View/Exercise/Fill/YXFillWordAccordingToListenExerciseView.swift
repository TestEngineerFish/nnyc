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
        super.createSubview()
        questionView = YXListenAndLackWordQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(answerView!)
        
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.questionView?.audioPlayerView?.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(180)
    }

    override func bindData() {
        self.remindView?.remindSteps = [[.example, .image, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
}
