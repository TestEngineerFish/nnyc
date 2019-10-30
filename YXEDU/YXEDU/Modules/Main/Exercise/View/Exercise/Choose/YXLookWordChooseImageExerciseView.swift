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
        answerView = YXImageAnswerView()
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func bindData() {
        
    }
}
