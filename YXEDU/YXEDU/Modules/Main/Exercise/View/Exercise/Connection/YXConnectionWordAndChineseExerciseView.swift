//
//  YXConnectionWordAndChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 连接单词和中文
class YXConnectionWordAndChineseExerciseView: YXBaseExerciseView {
    
    private let answerHeight: CGFloat = YXConnectionView.Config.itemHeight * 4 + YXConnectionView.Config.interval * 3
            
    override func createSubview() {
        questionView = YXBaseQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)
        
        answerView = YXConnectWordAndChineseAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(380)
        }
        
        self.answerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(140)
            make.left.right.equalToSuperview()
            make.height.equalTo(answerHeight)
        })
//        answerView?.frame = CGRect(x: 22, y: 108 + 32, width: screenWidth, height: answerHeight)
        
    }


}
