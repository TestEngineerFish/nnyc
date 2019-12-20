//
//  YXListenFillWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXListenFillWordExerciseView: YXBaseExerciseView {

    override func createSubview() {
        super.createSubview()
        questionView = YXListenFillQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXListenFillAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.scrollView.addSubview(answerView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.image], [.wordChinese], [.exampleWithDigWord, .exampleAudio], [.detail]]
    }

}
