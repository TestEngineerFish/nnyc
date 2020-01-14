//
//  YXValidationImageAndWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 判断图片和单词对错
class YXValidationImageAndWordExerciseView: YXBaseExerciseView {
        
    override func createSubview() {
        questionView = YXWordAndImageQuestionView(exerciseModel: exerciseModel)
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
        self.questionViewHeight = AdaptSize(230)
        
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.detail]]
    }

}
