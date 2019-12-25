//
//  YXLookWordChooseChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 看单词选中文
class YXLookWordChooseChineseExerciseView: YXBaseExerciseView {
    
    override func createSubview() {
        questionView = YXWordQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: self.exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXItemAnswerView(exerciseModel: exerciseModel)
        answerView?.answerDelegate = self
        self.scrollView.addSubview(answerView!)
        super.createSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example, .exampleAudio], [.image], [.detail]]
    }
}
