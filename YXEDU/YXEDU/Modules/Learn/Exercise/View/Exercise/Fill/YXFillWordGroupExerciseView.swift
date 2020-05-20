//
//  YXFillWordGroupExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 词组填空
class YXFillWordGroupExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXChineseFillQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)

        answerView = YXWordAnswerView(exerciseModel: exerciseModel)
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
        self.remindView?.remindSteps = [[.exampleWithDigWord], [.image], [.detail]]
    }
}
