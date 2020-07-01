//
//  YXNewLearnListExerciseView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNewLearnListExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXPickWordsBySelfView(frame: .zero, exerciseModel: exerciseModel) { (_exerciseModel) in
            YXLog("已选择，开始学习")
            guard let model = self.questionView?.exerciseModel else { return }
            self.answerCompletion(exercise: model, right: true)
        }
        questionView?.layer.removeShadow()
        self.addSubview(questionView!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
}
