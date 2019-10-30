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
        answerView = YXImageAnswerView()
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func bindData() {
        
    }

}
