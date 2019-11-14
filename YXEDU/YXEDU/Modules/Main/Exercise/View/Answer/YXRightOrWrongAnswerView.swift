//
//  YXRightOrWrongAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 对错答案
class YXRightOrWrongAnswerView: YXBaseAnswerView {
    

    var rightButton: UIButton = UIButton()
    var wrongButton: UIButton = UIButton()

    override func createSubviews() {
        super.createSubviews()
        self.bindProperty()
        self.addSubview(rightButton)
        self.addSubview(wrongButton)
    }

    override func layoutSubviews() {

        rightButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(22)
            make.height.equalTo(42)
        }
        
        wrongButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(rightButton.snp.right).offset(23)
            make.right.equalTo(-22)
            make.width.equalTo(rightButton.snp.width)
            make.height.equalTo(42)
        }
    }
    
    override func bindProperty() {
        self.rightButton.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .selected)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .highlighted)
        self.rightButton.setImage(UIImage(named: "exercise_answer_right"), for: .normal)
        self.rightButton.layer.masksToBounds = true
        self.rightButton.layer.cornerRadius = 21
        self.rightButton.layer.borderWidth = 1
        self.rightButton.layer.borderColor = UIColor.black6.cgColor

        
        self.wrongButton.addTarget(self, action: #selector(clickWrongButton), for: .touchUpInside)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .selected)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .highlighted)
        self.wrongButton.setImage(UIImage(named: "exercise_answer_wrong"), for: .normal)
        self.wrongButton.layer.masksToBounds = true
        self.wrongButton.layer.cornerRadius = 21
        self.wrongButton.layer.borderWidth = 1
        self.wrongButton.layer.borderColor = UIColor.black6.cgColor
    }
    
    
    @objc func clickRightButton() {
        self.rightButton.isSelected = true
        self.wrongButton.isSelected = false
        
        let result = exerciseModel.option?.firstItems?.first?.optionId == exerciseModel.answers?.first
        answerCompletion(right: result)
    }
    
    @objc func clickWrongButton() {
        self.rightButton.isSelected = false
        self.wrongButton.isSelected = true
        
        let result = exerciseModel.option?.firstItems?.last?.optionId == exerciseModel.answers?.first
        answerCompletion(right: result)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.wrongButton.isSelected = false
        }
    }

}
