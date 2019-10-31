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
    
    private let answerHeight: CGFloat = 42 * 4 + 13 * 3
            
    override func createSubview() {
        questionView = YXListenQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        answerView = YXImageAnswerView(exerciseModel: self.exerciseModel)
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.right.equalTo(0)
            make.height.equalTo(150)
        }
        
//        self.answerView?.snp.makeConstraints({ (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(answerHeight)
//        })
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
        
    }

}
