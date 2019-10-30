//
//  YXFillWordAccordingToChinese_ConnectionExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// /// 看中文填空，点击 + 连线两种操作
class YXFillWordAccordingToChinese_ConnectionExerciseView: YXBaseExerciseView {

    override func createSubview() {
        let word = "TableView"
        let itemNumberW = 5
        let itemNumberH = 5

        answerView = YXAnswerConnectionLettersView(word, itemNumberH: itemNumberH, itemNumberW: itemNumberW)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        answerView?.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
    }
    
    override func bindData() {
        
    }
    
}
