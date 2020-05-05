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
    /// 连线题，每个单词提示到哪一步
    private var remindMap: [Int : Int] = [:]
    private var answerHeight: CGFloat {
        let itemConfig = YXConnectionWordAndImageConfig()
        let count = CGFloat(exerciseModel.option?.firstItems?.count ?? 0)
        let height = (itemConfig.rightItemHeight + itemConfig.rightInterval) * count - itemConfig.rightInterval
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
        self.contentView.addSubview(remindView!)

        self.contentView.layer.setDefaultShadow()
    }
    
    
    override func layoutSubviews() {
        let itemConfig = YXConnectionWordAndImageConfig()
        let contentViewH = CGFloat(self.exerciseModel.option?.firstItems?.count ?? 0) * (itemConfig.rightItemHeight + itemConfig.rightInterval) + AdaptIconSize(94)
        self.contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.height.equalTo(contentViewH)
        }

        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(-12))
            make.centerX.equalToSuperview().offset(AdaptSize(10))
            make.width.equalTo(AdaptIconSize(231))
            make.height.equalTo(AdaptIconSize(87))
        }

        self.answerView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(AdaptIconSize(94))
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
    
    
    override func remindAction(wordId: Int, isRemind: Bool) {
        let word = selectWord(wordId: wordId)
        remindView?.exerciseModel.word = word
        
        if let index = remindMap[wordId] {
            remindView?.currentRemindIndex = index
            if isRemind {
                let count = self.remindView?.remindSteps.count ?? 0
                remindMap[wordId] = index + 1 >= count ? count - 1 : index + 1
            }
        } else {            
            remindMap[wordId] = -1
            remindView?.currentRemindIndex = -1
        }
    }
    
    func selectWord(wordId: Int) -> YXWordModel? {
        if exerciseModel.dataType == .base {
            let bookId = exerciseModel.word?.bookId ?? 0
            return YXWordBookDaoImpl().selectWord(bookId: bookId, wordId: wordId)
        } else {
            return YXWordBookDaoImpl().selectWord(wordId: wordId)
        }
    }
}
