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

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)
        
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
            make.height.equalTo(150)
        }
        
        self.answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(223)
        })
        
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example], [.exampleChinese], [.detail]]
    }

}
