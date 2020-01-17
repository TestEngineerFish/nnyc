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
    

    var rightButton = UIButton()
    var wrongButton = UIButton()

    override func createSubviews() {
        super.createSubviews()
        self.bindProperty()
        self.addSubview(rightButton)
        self.addSubview(wrongButton)
    }

    override func layoutSubviews() {

        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(AdaptSize(15))
            make.right.equalTo(self.snp.centerX).offset(AS(-19))
            make.height.width.equalTo(AdaptSize(100))
        }
        
        wrongButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(AdaptSize(15))
            make.left.equalTo(rightButton.snp.right).offset(AS(36))
            make.height.width.equalTo(AdaptSize(100))
        }
    }
    
    override func bindProperty() {
        self.rightButton.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
        self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
        self.rightButton.setImage(UIImage(named: "exercise_answer_right"), for: .normal)
        self.rightButton.setImage(UIImage(named: "exercise_answer_right_sel"), for: .selected)
        self.rightButton.setImage(UIImage(named: "exercise_answer_right_sel"), for: .highlighted)
        self.rightButton.layer.masksToBounds = true
        self.rightButton.layer.cornerRadius = AS(23.5)
        self.rightButton.layer.borderWidth = 0.5
        self.rightButton.layer.borderColor = UIColor.black6.cgColor

        self.wrongButton.addTarget(self, action: #selector(clickWrongButton), for: .touchUpInside)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
        self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
        self.wrongButton.setImage(UIImage(named: "exercise_answer_wrong"), for: .normal)
        self.wrongButton.setImage(UIImage(named: "exercise_answer_wrong_sel"), for: .selected)
        self.wrongButton.setImage(UIImage(named: "exercise_answer_wrong_sel"), for: .highlighted)
        self.wrongButton.layer.masksToBounds = true
        self.wrongButton.layer.cornerRadius = AS(23.5)
        self.wrongButton.layer.borderWidth = 0.5
        self.wrongButton.layer.borderColor = UIColor.black6.cgColor
    }
    
    
    @objc func clickRightButton() {
        self.rightButton.isSelected = true
        self.wrongButton.isSelected = false
        
        let result = exerciseModel.option?.firstItems?.first?.optionId == exerciseModel.answers?.first
        answerCompletion(right: result)
        
        if result {
            self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .selected)
            self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .highlighted)
            
        } else {
            self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
            self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
            self.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
            self.rightButton.setImage(#imageLiteral(resourceName: "exercise_answer_right_wrong"), for: .normal)
            self.rightButton.setImage(#imageLiteral(resourceName: "exercise_answer_right_wrong"), for: .selected)
            self.rightButton.setImage(#imageLiteral(resourceName: "exercise_answer_right_wrong"), for: .highlighted)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
                self?.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
                self?.rightButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
                self?.rightButton.setImage(UIImage(named: "exercise_answer_right"), for: .normal)
                self?.rightButton.setImage(UIImage(named: "exercise_answer_right_sel"), for: .selected)
                self?.rightButton.setImage(UIImage(named: "exercise_answer_right_sel"), for: .highlighted)
                
                self?.rightButton.isSelected = false
            }
        }
    }
    
    @objc func clickWrongButton() {
        self.rightButton.isSelected = false
        self.wrongButton.isSelected = true
        
        let result = exerciseModel.option?.firstItems?.last?.optionId == exerciseModel.answers?.first
        answerCompletion(right: result)
        
        if result {
            self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .selected)
            self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .highlighted)
            
        } else {
            self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
            self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
            self.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
            self.wrongButton.setImage(#imageLiteral(resourceName: "exercise_answer_wrong_right"), for: .normal)
            self.wrongButton.setImage(#imageLiteral(resourceName: "exercise_answer_wrong_right"), for: .selected)
            self.wrongButton.setImage(#imageLiteral(resourceName: "exercise_answer_wrong_right"), for: .highlighted)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
                self?.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
                self?.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .selected)
                self?.wrongButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .highlighted)
                self?.wrongButton.setImage(UIImage(named: "exercise_answer_wrong"), for: .normal)
                self?.wrongButton.setImage(UIImage(named: "exercise_answer_wrong_sel"), for: .selected)
                self?.wrongButton.setImage(UIImage(named: "exercise_answer_wrong_sel"), for: .highlighted)
                
                self?.wrongButton.isSelected = false
            }
        }
    }

}
