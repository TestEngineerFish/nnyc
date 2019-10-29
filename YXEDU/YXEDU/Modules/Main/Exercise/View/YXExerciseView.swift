//
//  YXExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习模块：内容主页面，包括题目View、答案View、TipsView
class YXExerciseView: UIScrollView {

    var exerciseModel: YXWordExerciseModel?
    //    var questionView: YXExerciseQuestionView?
    //    var answerView: YXExerciseAnswerView?
    private var questionView = YXQuestionView()
    
    weak var exerciseDelegate: YXExerciseViewDelegate?
    
    deinit {
        print("练习view 释放")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapView() {

        let word = "Coffee"
        let lettersArray = word.map { (char) -> String in
            return "\(char)"
        }
        let itemNumberW = 5
        let itemNumberH = 5
        // 查找最佳路径
        var util = YXFindRouteUtil(itemNumberH, itemNumberW: itemNumberW)
        let startIndex = Int(arc4random()) % (itemNumberH * itemNumberW)
        let routes = util.getRoute(start: startIndex, wordLength: lettersArray.count)

        let answerView = YXAnswerConnectionLettersView(lettersArray, itemNumberH: itemNumberH, itemNumberW: itemNumberW, rightRoutes: routes)
        self.addSubview(answerView)

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


    
    
    
    
    /// 动画入场，动画从右边往左边显示出来
    func animateAdmission(_ first: Bool = false, _ completion: (() -> Void)?) {
        
        self.origin.x = screenWidth
        UIView.animate(withDuration: 0.4, delay: first ? 0.4 : 0.2, options: [], animations: {
            self.origin.x = 0
        }) { (finish) in
            if finish {
                completion?()
            }
        }
    }
    
    
    /// 动画出场
    func animateRemove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.origin.x = -screenWidth
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
}


extension YXExerciseView {

    //MARK: YXQuestionViewConstraintsProtocol
    func updateHeight(_ height: CGFloat) {
        //        self.questionView.snp.updateConstraints { (make) in
        //            make.height.equalTo(height)
        //        }
    }


    //MARK: YXAnswerEventProtocol
    func clickWordButton(_ button: UIButton) {
        //        button.isSelected = !button.isSelected
        //        button.backgroundColor = button.isSelected ? UIColor.orange1 : UIColor.white
    }


}
