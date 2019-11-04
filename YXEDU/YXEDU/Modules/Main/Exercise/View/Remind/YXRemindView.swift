//
//  YXRemindView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/2.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

class YXRemindView: UIView {

    var exerciseModel: YXWordExerciseModel
    var remindLabel = UILabel()

    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.createSubview()
    }

    private func createSubview() {
        remindLabel.font          = UIFont.pfSCRegularFont(withSize: 12)
        remindLabel.text          = "提示:"
        remindLabel.textColor     = UIColor.gray1
        remindLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
