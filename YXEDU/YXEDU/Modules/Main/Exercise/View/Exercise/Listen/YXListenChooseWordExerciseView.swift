//
//  YXListenChooseWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音选单词
class YXListenChooseWordExerciseView: YXBaseExerciseView {
        
    override func createSubview() {
        super.createSubview()
        questionView = YXListenQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)

        answerView = YXItemAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        (answerView as! YXItemAnswerView).titleLabel.font = UIFont.boldSystemFont(ofSize: AdaptSize(14))
        self.scrollView.addSubview(answerView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(130)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.image], [.wordChinese], [.exampleWithDigWord, .exampleAudio], [.detail]]
    }

}
