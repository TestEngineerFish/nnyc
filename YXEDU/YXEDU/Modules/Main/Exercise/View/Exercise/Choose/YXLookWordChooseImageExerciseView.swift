//
//  YXLookWordChooseImageExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/29.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 看单词选图片
class YXLookWordChooseImageExerciseView: YXBaseExerciseView {
    
    override func createSubview() {
        super.createSubview()
        questionView = YXWordQuestionView(exerciseModel: self.exerciseModel)
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
        self.remindView?.remindSteps = [[.example, .wordAudio, .exampleAudio], [.exampleChinese], [.detail]]            
    }
    
}
