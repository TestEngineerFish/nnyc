//
//  YXNewLearnJuniorHighSchoolAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnJuniorHighSchool: YXBaseAnswerView {
    let masteredButton = YXButton()
    let unknownButton  = YXButton()
    override func createSubviews() {
        super.createSubviews()
        let defaultH = AdaptSize(42)
        masteredButton.backgroundColor    = UIColor.hex(0xFFE9C7)
        unknownButton.backgroundColor     = UIColor.hex(0xFFF7DC)
        masteredButton.layer.cornerRadius = defaultH/2
        unknownButton.layer.cornerRadius  = defaultH/2
        masteredButton.setTitle("已掌握", for: .normal)
        unknownButton.setTitle("不认识", for: .normal)
        masteredButton.setTitleColor(UIColor.hex(0x4F4F4F), for: .normal)
        unknownButton.setTitleColor(UIColor.hex(0x4F4F4F), for: .normal)
        masteredButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        unknownButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        masteredButton.addTarget(self, action: #selector(clickMastered), for: .touchUpInside)
        unknownButton.addTarget(self, action: #selector(clickUnknown), for: .touchUpInside)

        self.addSubview(masteredButton)
        self.addSubview(unknownButton)
        masteredButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(AdaptSize(154))
            make.height.equalTo(defaultH)
        }
        unknownButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.width.equalTo(AdaptSize(154))
            make.height.equalTo(AdaptSize(defaultH))
        }
    }

    @objc private func clickMastered() {
        print("已掌握")
        self.exerciseModel.score = 7
        self.answerDelegate?.answerCompletion(self.exerciseModel, true)
    }

    @objc private func clickUnknown() {
        print("不认识")
        self.exerciseModel.score = 0
        self.answerDelegate?.answerCompletion(self.exerciseModel, true)
    }
}
