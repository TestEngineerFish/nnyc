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
        masteredButton.backgroundColor     = UIColor.white
        unknownButton.backgroundColor      = UIColor.white
        masteredButton.layer.cornerRadius  = defaultH/2
        unknownButton.layer.cornerRadius   = defaultH/2
        masteredButton.layer.borderWidth   = AdaptSize(1)
        unknownButton.layer.borderWidth    = AdaptSize(1)
        masteredButton.layer.borderColor   = UIColor.black6.cgColor
        unknownButton.layer.borderColor    = UIColor.black6.cgColor
        masteredButton.layer.masksToBounds = true
        unknownButton.layer.masksToBounds  = true
        masteredButton.setTitle("已掌握", for: .normal)
        unknownButton.setTitle("不认识", for: .normal)
        masteredButton.setTitleColor(UIColor.black1, for: .normal)
        unknownButton.setTitleColor(UIColor.black1, for: .normal)
        masteredButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        unknownButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        masteredButton.addTarget(self, action: #selector(clickMastered), for: .touchUpInside)
        unknownButton.addTarget(self, action: #selector(clickUnknown), for: .touchUpInside)

        self.addSubview(masteredButton)
        self.addSubview(unknownButton)
        masteredButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(27))
            make.top.equalToSuperview().offset(AdaptSize(11))
            make.width.equalTo(AdaptSize(154))
            make.height.equalTo(defaultH)
        }
        unknownButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-27))
            make.top.equalToSuperview().offset(AdaptSize(11))
            make.width.equalTo(AdaptSize(154))
            make.height.equalTo(AdaptSize(defaultH))
        }
    }

    @objc private func clickMastered() {
        self.exerciseModel.score = 7
        self.answerDelegate?.answerCompletion(self.exerciseModel, true)
    }

    @objc private func clickUnknown() {
        self.exerciseModel.score = 0
        self.answerDelegate?.answerCompletion(self.exerciseModel, true)
    }
}
