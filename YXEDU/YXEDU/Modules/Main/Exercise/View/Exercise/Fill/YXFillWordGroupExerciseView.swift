//
//  YXFillWordGroupExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 词组填空
class YXFillWordGroupExerciseView: YXBaseExerciseView {

    override func createSubview() {
        super.createSubview()
        questionView = YXChineseFillQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)
        remindView?.backgroundColor = UIColor.orange1

        answerView = YXWordAnswerView(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(180)
        }

        remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(questionView!.snp.bottom).offset(15)
            make.left.width.equalTo(questionView!)
            make.height.equalTo(150)
        })

        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(remindView!.snp.bottom)
            make.width.equalTo(300)
            make.bottom.equalToSuperview()
        })
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.example], [.image], [.detail]]
    }
}
