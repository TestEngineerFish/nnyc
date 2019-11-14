//
//  YXNewLearnJuniorHighSchoolView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnJuniorHighSchoolExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXNewLearnJuniorHighSchoolQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        answerView = YXNewLearnJuniorHighSchool(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        answerView?.answerDelegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        answerView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(questionView!)
            make.height.equalTo(AdaptSize(42))
            make.bottom.equalToSuperview()
        })

        questionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.bottom.equalTo(answerView!.snp.top).offset(-AdaptSize(15))
        })
    }
}
