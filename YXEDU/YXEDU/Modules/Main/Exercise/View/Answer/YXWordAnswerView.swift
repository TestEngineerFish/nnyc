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
        for (index, item) in itemList.enumerated() {
            let x = (index % 2 > 0) ? itemW + marginH : 0
            let y = CGFloat(index / 2) * (marginV + itemH)
            let button = YXLetterButton()
            button.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
            button.status = .normal
            button.setTitle(item.content ?? "", for: .normal)
            button.tag = item.optionId
            button.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
            self.contentScrollView?.addSubview(button)
            self.allBtnArray.append(button)
        }

        self.maxX = self.allBtnArray.last?.frame.maxY ?? 0
        self.contentScrollView?.contentSize = CGSize(width: 300, height: self.maxX)
    }

    @objc private func clickBtn(_ button: YXLetterButton) {
        if button.status == .selected || button.status == .error {
            button.status = .normal
            self.delegate?.unselectAnswerButton(button)
            if let index = self.selectedBtnArray.firstIndex(of: button) {
                self.selectedBtnArray.remove(at: index)
            }
        } else {
            let index = delegate?.selectedAnswerButton(button)
            if let _index = index, !self.selectedBtnArray.contains(button) {
                button.status = .selected
                self.selectedBtnArray.insert(button, at: _index)
                if self.selectedBtnArray.count >= self.exerciseModel.answers?.count ?? 0 {
                    // 检查结果
                    let errList = self.checkAnserResult(button)
                    // 更新UI
                    self.showResultView(errorList: errList)
                    // 更新问题UI
                    self.delegate?.showResult(errorList: errList)
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
            for id in list {
                if let button = self.selectedBtnArray.first(where: { (button) -> Bool in
                    return button.tag == id
                }) {
                    button.status = .error
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, false)
        }
    }

}
