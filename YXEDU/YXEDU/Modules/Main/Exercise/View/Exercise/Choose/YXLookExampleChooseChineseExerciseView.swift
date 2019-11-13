//
//  YXLookExampleChooseChinese.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 看例句选中文
class YXLookExampleChooseChineseExerciseView: YXBaseExerciseView {

    private let answerHeight: CGFloat = 42 * 4 + 13 * 3
    
    override func createSubview() {
        questionView = YXExampleQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: self.exerciseModel)
        self.addSubview(remindView!)
        
        answerView = YXItemAnswerView(exerciseModel: exerciseModel)
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
        
        self.remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(questionView!.snp.bottom).offset(15)
            make.left.width.equalTo(questionView!)
            make.height.equalTo(150)
        })

        
        self.answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(answerHeight)
        })
        
        
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.image], [.detail]]
    }

}
