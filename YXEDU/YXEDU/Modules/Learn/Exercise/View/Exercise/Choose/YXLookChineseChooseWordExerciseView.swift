//
//  YXLookChineseChooseWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 看中文选单词
class YXLookChineseChooseWordExerciseView: YXBaseExerciseView {
        
    override func createSubview() {
        questionView = YXChineseQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: self.exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXItemAnswerView(exerciseModel: exerciseModel)
        answerView?.answerDelegate = self
        (answerView as! YXItemAnswerView).titleFont = UIFont.boldSystemFont(ofSize: AdaptFontSize(14))
        self.scrollView.addSubview(answerView!)
        super.createSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(isPad() ? 192 : 160)
    }

    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord], [.image], [.detail]]
    }
}
