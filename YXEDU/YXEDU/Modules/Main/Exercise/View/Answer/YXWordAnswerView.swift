//
//  YXWordAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 单词答案(填空)
class YXWordAnswerView: YXBaseAnswerView {

    let itemW   = CGFloat(140)
    let itemH   = CGFloat(45)
    let marginH = CGFloat(20)
    let marginV = CGFloat(10)
    var maxX    = CGFloat.zero
    var allBtnArray      = [YXWordButton]()
    var selectedBtnArray = [YXWordButton]()

    override func createSubview() {
        super.createSubview()
        for index in 0..<self.exerciseModel.wordArray.count {
            let word = self.exerciseModel.wordArray[index]
            let x = (index % 2 > 0) ? itemW + marginH : 0
            let y = CGFloat(index / 2) * (marginV + itemH)
            let button = YXWordButton()
            button.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
            button.status = .normal
            button.setTitle(word, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
            self.contentScrollView?.addSubview(button)
            self.allBtnArray.append(button)
        }
        self.maxX = self.allBtnArray.last?.frame.maxY ?? 0
        self.contentScrollView?.contentSize = CGSize(width: 300, height: self.maxX)
    }

    @objc private func clickBtn(_ button: YXWordButton) {
        if button.status == .selected {
            button.status = .normal
        } else {
            button.status = .selected
        }
    }

}
