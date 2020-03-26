//
//  YXNewLearnJuniorHighSchoolView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
/// 初中新学
class YXNewLearnJuniorHighSchoolExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXNewLearnJuniorHighSchoolQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        answerView = YXNewLearnJuniorHighSchool(exerciseModel: exerciseModel)
        self.addSubview(answerView!)
        answerView?.layer.setDefaultShadow()

        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        answerView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(YXExerciseConfig.exerciseViewBottom)
            make.bottom.equalToSuperview()
        })

        questionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(32)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(answerView!.snp.top).offset(-AdaptSize(15))
        })
    }
}
