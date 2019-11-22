//
//  YXConnectionWordAndImageExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 连接单词和图片
class YXConnectionWordAndImageExerciseView: YXBaseExerciseView {

    var contentView = UIView()

    private var answerHeight: CGFloat {
        let itemConfig = YXConnectionWordAndImageConfig()
        let height = (itemConfig.rightItemHeight + itemConfig.rightInterval)*4 - itemConfig.rightInterval
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
        self.contentView.addSubview(remindView!)

        self.contentView.layer.setDefaultShadow()
    }
    
    
    override func layoutSubviews() {

        self.contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.height.equalTo(AdaptSize(442))
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
        self.remindView?.remindSteps = [[.example], [.wordChinese], [.detail]]
    }
}
