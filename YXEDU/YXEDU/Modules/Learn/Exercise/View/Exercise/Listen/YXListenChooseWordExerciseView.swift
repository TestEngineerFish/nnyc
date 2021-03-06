//
//  YXListenChooseWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听例句读音选单词
class YXListenChooseWordExerciseView: YXBaseExerciseView {
        
    override func createSubview() {
        questionView = YXListenQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)

        answerView = YXItemAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        (answerView as! YXItemAnswerView).titleLabel.font = UIFont.boldSystemFont(ofSize: AdaptFontSize(14))
        self.scrollView.addSubview(answerView!)
        super.createSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(isPad() ? 192 : 130)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.image], [.wordChinese], [.exampleWithDigWord, .exampleAudio], [.detail]]
    }

}
