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

    private let answerHeight: CGFloat = 42 * 4 + 13 * 3
        
    override func createSubview() {
        super.createSubview()
        questionView = YXChineseQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: self.exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXItemAnswerView(exerciseModel: exerciseModel)
        answerView?.answerDelegate = self
        (answerView as! YXItemAnswerView).titleFont = UIFont.boldSystemFont(ofSize: AdaptSize(14))
        self.scrollView.addSubview(answerView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(160)
    }

    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord], [.image], [.detail]]
    }
}
