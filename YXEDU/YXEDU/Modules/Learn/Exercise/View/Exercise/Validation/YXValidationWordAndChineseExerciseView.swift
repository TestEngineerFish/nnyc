//
//  YXValidationWordAndChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 判断单词和词义对错
class YXValidationWordAndChineseExerciseView: YXBaseExerciseView {
    private let answerHeight: CGFloat = 42
        
    override func createSubview() {
        questionView = YXWordAndChineseQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXRightOrWrongAnswerView(exerciseModel: exerciseModel)
        answerView?.answerDelegate = self
        self.scrollView.addSubview(answerView!)
        super.createSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(isPad() ? 192 : 160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.detail]]
    }
}
