//
//  YXNewLearnPrimarySchoolExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 小学新学
class YXNewLearnPrimarySchoolExerciseView: YXBaseExerciseView {

    var squirrelImageView = UIImageView()
    var tipsImageView     = UIImageView()

    override func createSubview() {
        super.createSubview()
        questionView = YXNewLearnPrimarySchoolQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        answerView = YXNewLearnAnswerView(exerciseModel: self.exerciseModel)
        self.addSubview(answerView!)

        questionView?.delegate     = answerView
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(37)
            make.height.equalTo(250)
            make.width.equalToSuperview().offset(-44)
        })
        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionView!.snp.bottom).offset(90)
            make.width.equalToSuperview().offset(-44)
            make.height.equalTo(200)
        })
    }

}
