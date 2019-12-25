//
//  YXListenChooseImageExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音选图片
class YXListenChooseImageExerciseView: YXBaseExerciseView {
            
    override func createSubview() {
        questionView = YXListenQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXImageAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.scrollView.addSubview(answerView!)
        super.createSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(130)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example], [.exampleChinese], [.detail]]
    }

}
