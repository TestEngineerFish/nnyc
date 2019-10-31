//
//  YXSelectLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAnswerSelectLettersView: YXBaseAnswerView {
    let contentView = UIView()

    let itemSize     = CGFloat(60)
    let margin       = CGFloat(10)
    let horItemNum   = 4
    var verItemNum   = 3
    var buttonArray2 = [[UIButton]]()

    override func createSubview() {
        super.createSubview()
        self.createButtonArray(exerciseModel.wordArray)
        self.createUI()
    }

    private func createUI() {
        addSubview(contentView)
        let contentW = getContentW()
        var contentH = getContentH()//可以不用
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(contentW)
            make.height.equalTo(contentH)
        }
        var maxY = CGFloat(0)
        for buttonArray in buttonArray2 {
            let cellView = UIView()
            contentView.addSubview(cellView)
            cellView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(maxY)
                make.centerX.equalToSuperview()
                make.height.equalTo(itemSize)
            }
            var maxX = CGFloat(0)
            for button in buttonArray {
                cellView.addSubview(button)
                let width: CGFloat = {
                    let w = CGFloat(button.tag) * itemSize
                    return button.tag > 1 ? w + margin : w
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
        contentH = maxY - margin
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentH)
        }
        
    }

    /// 根据单词数组,生成一行一组按钮的二维数组
    private func createButtonArray(_ wordsArray: [String]) {
        var wordsBtnArray2 = Array(repeating: [UIButton](), count: 3)
        // 1、生成按钮组
        for word in wordsArray {
            let button = self.createWordButton(word)
            // 1.1、遍历二维数组中,是否需要插入对应单词
            for index in 0..<wordsBtnArray2.count {
                let btnArray = wordsBtnArray2[index]
                var cellCount = 0
                for btn in btnArray {
                    cellCount += btn.tag
                }
                // 1.2、补齐数组
                if button.tag + cellCount <= horItemNum {
                    wordsBtnArray2[index].append(button)
                    break
                }
            }
        }
        self.buttonArray2 = wordsBtnArray2
    }

    /// 创建单词按钮
    private func createWordButton(_ word: String) -> UIButton {
        let button = UIButton()
        button.tag = 1
        button.backgroundColor   = UIColor.white
        button.layer.borderColor = UIColor.hex(0xC0C0C0).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.setTitle(word, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        if word.count > 4 {
            button.tag = 2
        }
        return button
    }

    // TODO: Event

    @objc func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        button.backgroundColor = button.isSelected ? UIColor.orange1 : UIColor.white
        delegate?.clickWordButton(button)
        
        // 做题完成时，调用父类方法
        answerCompletion(right: true)
    }

    // TODO: Tools
    /// 获取内容视图宽
    private func getContentW() -> CGFloat {
        let width = CGFloat(horItemNum) * (itemSize + margin) - margin
        return width
    }

     /// 获取内容视图高
    private func getContentH() -> CGFloat {
        let height = CGFloat(verItemNum) * (itemSize + margin) - margin
        return height
    }

}
