//
//  YXExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习模块：内容主页面，包括题目View、答案View、TipsView
class YXExerciseView: YXBaseExerciseView {
    
    deinit {
        print("练习view 释放")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.tapView()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
//        self.addGestureRecognizer(tap)
//        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapView() {

        let word = "TableView"
        
        let itemNumberW = 5
        let itemNumberH = 5

        let answerView = YXAnswerConnectionLettersView(word, itemNumberH: itemNumberH, itemNumberW: itemNumberW)
        self.addSubview(answerView)
        answerView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        
    }
    // ==== 添加选择视图 ====
    //       let answerView = YXAnswerSelectLettersView(wordArray)
    ////        answerView.delegate = self
    //       kWindow.addSubview(answerView)
    //       answerView.snp.makeConstraints { (make) in
    //           make.centerX.equalToSuperview()
    //           make.width.equalTo(270)
    //           make.height.equalTo(200)
    //           make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
    //       }
    // ===== 数据准备 ====
    //        var charModelsArray = [YXCharacterModel]()
    //        for index in 0..<2 {
    //            let model = YXCharacterModel("sam", isBlank: index%2>0)
    //            charModelsArray.append(model)
    //        }
    //        let wordArray = ["e", "f", "u", "pdsss", "wddesa", "v", "m", "x"]
    //
    //        // ==== 添加问题根视图 ====
    //        let questionView = YXQuestionView()
    //        questionView.delegate = self
    //        self.contentScrollView.addSubview(questionView)
    //        questionView.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.top.equalToSuperview().offset(kNavHeight)
    //            make.width.equalTo(332)
    //            make.height.equalTo(160)
    //        }
    //
    //        // ==== 添加子视图 ====
    //        let charView = YXQuestionSpellView(charModelsArray)
    //        questionView.addCustomViews([charView])
    //
    //        // ==== 添加选择视图 ====
    //        let answerView = YXAnswerSelectLettersView(wordArray)
    //        answerView.delegate = self
    //        kWindow.addSubview(answerView)
    //        answerView.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.width.equalTo(270)
    //            make.height.equalTo(200)
    //            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
    //        }


}

