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
        questionView = YXWordQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)
        
        answerView = YXImageAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(180)
        }
        
        self.answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(223)
        })
    }

}
