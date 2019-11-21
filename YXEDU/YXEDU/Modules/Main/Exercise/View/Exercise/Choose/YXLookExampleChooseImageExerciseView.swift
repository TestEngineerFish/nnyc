//
//  YXLookExampleChooseImage.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// // 看例句选图片
class YXLookExampleChooseImageExerciseView: YXBaseExerciseView {

    override func createSubview() {
        super.createSubview()
        questionView = YXExampleQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: self.exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXImageAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.scrollView.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.exampleChinese, .wordAudio], [.wordChinese, .wordAudio], [.detail]]
    }
}
