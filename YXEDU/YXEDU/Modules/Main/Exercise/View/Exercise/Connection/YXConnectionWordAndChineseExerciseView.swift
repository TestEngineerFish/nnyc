//
//  YXConnectionWordAndChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 连接单词和中文
class YXConnectionWordAndChineseExerciseView: YXBaseExerciseView {

    var contentView = UIView()

    private var answerHeight: CGFloat {
        let itemConfig = YXConnectionWordAndChineseConfig()
        let height = (itemConfig.leftItemHeight + itemConfig.leftInterval)*4 - itemConfig.leftInterval
        return height
    }
            
    override func createSubview() {
        self.addSubview(contentView)
        self.contentView.backgroundColor = UIColor.white

        questionView = YXConnectionQuestionView(exerciseModel: self.exerciseModel)
        self.contentView.addSubview(questionView!)
        
        answerView = YXConnectionAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        self.contentView.addSubview(answerView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        remindView?.delegate = self
        self.addSubview(remindView!)

        self.contentView.layer.setDefaultShadow()
    }
    
    
    override func layoutSubviews() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.height.equalTo(AdaptSize(380))
        }

        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(-12))
            make.centerX.equalToSuperview().offset(AdaptSize(10))
            make.width.equalTo(AdaptSize(231))
            make.height.equalTo(AdaptSize(87))
        }

        self.answerView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(AdaptSize(108))
            make.left.right.equalToSuperview()
            make.height.equalTo(answerHeight)
        })
        
        remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.bottom).offset(15)
            make.left.width.equalTo(contentView)
            make.bottom.equalToSuperview().priorityLow()
        })
    }

    override func bindData() {
        self.remindView?.remindSteps = [[.example], [.image], [.detail]]
    }

    override func updateHeightConstraints(_ height: CGFloat) {
        let remindViewH = self.height - self.contentView.frame.maxY
        let lackH = height - remindViewH
        if lackH > 0 {
            self.remindView?.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.transform = CGAffineTransform(translationX: 0, y: -lackH)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                UIView.animate(withDuration: 0.5) {
                    self.transform = .identity
                }
                self.remindView?.isHidden = true
            }
        }
    }
    
    
}
