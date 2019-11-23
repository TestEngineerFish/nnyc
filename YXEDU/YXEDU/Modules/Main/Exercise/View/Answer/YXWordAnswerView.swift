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
    var allBtnArray      = [YXLetterButton]()
    var selectedBtnArray = [YXLetterButton]()

    override func createSubviews() {
        super.createSubviews()
        guard let itemList = self.exerciseModel.option?.firstItems else {
            return
        }
        let contentView = UIView()
        for (index, item) in itemList.enumerated() {
            let x = (index % 2 > 0) ? itemW + marginH : 0
            let y = CGFloat(index / 2) * (marginV + itemH)
            let button = YXLetterButton()
            button.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
            button.status = .normal
            button.setTitle(item.content ?? "", for: .normal)
            button.tag = index + offsetTag
            button.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
            contentView.addSubview(button)
            self.allBtnArray.append(button)
        }

        self.maxX = self.allBtnArray.last?.frame.maxY ?? 0
        self.addSubview(contentView)
        let contentViewW = (itemW + marginH)*2 - marginH
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(contentViewW)
            make.height.equalTo(self.maxX)
        }
    }

    @objc private func clickBtn(_ button: YXLetterButton) {
        if button.status == .selected || button.status == .error {
            let tmpButtonArray = self.selectedBtnArray.filter { (selButton) -> Bool in
                if selButton.tag == button.tag {
                    selButton.status = .normal
                    return false
                } else {
                    return true
                }
            }
            self.selectedBtnArray = tmpButtonArray
            delegate?.unselectAnswerButton(button)
        } else {
            // 通过回调更新选中顺序,也可防止同时选中多个
            let success = delegate?.selectedAnswerButton(button) ?? false
            if !self.selectedBtnArray.contains(button) && success {
                button.status = .selected
                self.selectedBtnArray.append(button)
                if let result = self.delegate?.checkResult(), result.0 {
                    self.showResultView(errorList: result.1)
                }
            }
        }
    }

    // MARK: 结果相关
    private func checkAnserResult(_ button: YXLetterButton) -> [Int] {
        var errList = [Int]()
        guard let answers = self.exerciseModel.answers else {
            return errList
        }
        for (index, button) in self.selectedBtnArray.enumerated() {
            if index >= answers.count { break }
            let rightId   = answers[index]
            let currentId = button.tag
            if rightId != currentId {
                errList.append(currentId)
            }
        }
        return errList
    }

    /// 显示结果页
    private func showResultView(errorList list: [Int]) {
        if list.isEmpty {
            // 答题正确
            self.selectedBtnArray.forEach { (button) in
                button.status = .right
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, true)
        } else {
            var firstButton: YXLetterButton?
            for id in list {
                self.selectedBtnArray.forEach { (letterButton) in
                    if letterButton.tag == id {
                        if firstButton == nil {
                            firstButton = letterButton
                        }
                        letterButton.status = .error
                    }
                }
            }
            if let button = firstButton {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                    self.clickBtn(button)
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, false)
        }
    }

}
