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
//        questionView = YXWordQuestionView()
//        self.addSubview(questionView!)
        
        answerView = YXImageAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.
        
        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.right.equalTo(0)
            make.height.equalTo(180)
        }
        
        answerView?.frame = CGRect(x: 0, y: self.size.height - 223, width: screenWidth, height: 223)
        
    }
    
    
    override func bindData() {
        
    }
}
