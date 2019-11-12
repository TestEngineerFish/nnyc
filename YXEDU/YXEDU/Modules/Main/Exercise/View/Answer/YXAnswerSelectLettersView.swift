//
//  YXSelectLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 选择字母答题页面
class YXAnswerSelectLettersView: YXBaseAnswerView {

    let itemSize     = CGFloat(60)
    let margin       = CGFloat(10)
    let horItemNum   = 4
    var verItemNum   = 3
    var buttonArray2 = [[YXLetterButton]]()
    var selectedBtnArray = [YXLetterButton]()
    let offsetTag    = 100

    override func createSubview() {
        super.createSubview()
        guard let itemList = self.exerciseModel.option?.firstItems else {
            return
        }
        self.createButtonArray(itemList)
        self.createUI()
    }

    private func createUI() {
        var maxY = CGFloat(0)
        for buttonArray in buttonArray2 {
            let cellView = UIView()
            contentScrollView?.addSubview(cellView)
            cellView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(maxY)
                make.centerX.equalToSuperview()
                make.height.equalTo(itemSize)
            }
            var maxX = CGFloat(0)
            for button in buttonArray {
                cellView.addSubview(button)
                let width: CGFloat = {
                    let w = CGFloat(button.widthUnit) * itemSize
                    return button.widthUnit > 1 ? w + margin : w
                }()
                button.snp.makeConstraints { (make) in
                    make.left.equalTo(maxX)
                    make.top.equalToSuperview()
                    make.width.equalTo(width)
                    make.height.equalTo(itemSize)
                }
                maxX += margin + width
            }
            maxX -= margin
            cellView.snp.makeConstraints { (make) in
                make.width.equalTo(maxX)
            }
            maxY += itemSize + margin
        }
        let contentH = maxY - margin
        contentScrollView?.contentSize = CGSize(width: 270, height: contentH)
    }

    /// 根据单词数组,生成一行一组按钮的二维数组
    private func createButtonArray(_ itemList: [YXOptionItemModel]) {
        var wordsBtnArray2 = Array(repeating: [YXLetterButton](), count: 3)
        // 1、生成按钮组
        for item in itemList {
            let button = self.createWordButton(item.content)
            button.tag = item.optionId + offsetTag
            // 1.1、遍历二维数组中,是否需要插入对应单词
            for index in 0..<wordsBtnArray2.count {
                let btnArray = wordsBtnArray2[index]
                var cellCount = 0
                for btn in btnArray {
                    cellCount += btn.widthUnit
                }
                // 1.2、补齐数组
                if button.widthUnit + cellCount <= horItemNum {
                    wordsBtnArray2[index].append(button)
                    break
                }
            }
        }
        self.buttonArray2 = wordsBtnArray2
    }

    /// 创建单词按钮
    private func createWordButton(_ word: String?) -> YXLetterButton {
        let button = YXLetterButton()
        button.text   = word
        button.status = .normal
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return button
    }

    // TODO: Event

    @objc func clickButton(_ button: YXLetterButton) {
        if button.status == .selected || button.status == .error {
            if let index = self.selectedBtnArray.firstIndex(of: button) {
                self.selectedBtnArray.remove(at: index)
                button.status = .normal
            }
            delegate?.unselectAnswerButton(button)
        } else {
            // 通过回调更新选中顺序,也可防止同时选中多个
            let index = delegate?.selectedAnswerButton(button) ?? 0
            if !self.selectedBtnArray.contains(button) {
                button.status = .selected
                self.selectedBtnArray.insert(button, at: index)
                if self.selectedBtnArray.count >= self.exerciseModel.answers?.count ?? 0 {
                    // 检查结果
                    let errList = self.checkAnserResult()
                    // 更新UI
                    self.showResultView(errorList: errList)
                    // 更新问题UI
                    self.delegate?.showResult(errorList: errList)
                }
            }
        }
    }

    /// 检查结果.如果有错误的则返回对应错误的ID数组,否则返回空数组
    private func checkAnserResult() -> [Int] {
        var errList = [Int]()
        guard let answers = self.exerciseModel.answers else {
            return errList
        }
        for (index, button) in self.selectedBtnArray.enumerated() {
            if index >= answers.count { break }
            let rightId   = answers[index]
            let currentId = button.tag - offsetTag
            if rightId != currentId {
                errList.append(currentId + offsetTag)
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
