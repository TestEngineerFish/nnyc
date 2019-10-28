//
//  YXAnswerConnectionLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAnswerConnectionLettersView: UIView {

    var buttonArray = [UIButton]()
    var selectedBtnArray = [UIButton]() // 选中的按钮
    // 正确的字母路径
    var rightRoutes: [Int]
    // 完整的字母
    var allLettersArray = [String]()
    // 正确的字母数组
    var lettersArray = [String]()
    var itemNumberH: Int
    var itemNumberW: Int
    let margin       = CGFloat(8)
    let itemSize     = CGFloat(48)

    init(_ letters: [String], itemNumberH: Int, itemNumberW: Int, rightRoutes: [Int]) {
        self.itemNumberH = itemNumberH
        self.itemNumberW = itemNumberW
        self.rightRoutes = rightRoutes
        let w = CGFloat(itemNumberW) * (margin + itemSize) - margin
        let h = CGFloat(itemNumberH) * (margin + itemSize) - margin
        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))
        self.lettersArray = letters
        self.allLettersArray = self.getAllLetters(rightRoutes)
        print(allLettersArray)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        buttonArray = []
        selectedBtnArray = []
        var maxX = CGFloat.zero
        var maxY = CGFloat.zero
        for index in 0..<allLettersArray.count {
            let letter = self.allLettersArray[index]
            let button = self.createButton(letter)
            button.tag = index
            button.frame = CGRect(x: maxX, y: maxY, width: itemSize, height: itemSize)
            let nextX = maxX + margin + itemSize
            if nextX > self.bounds.width {
                maxX = 0
                maxY += itemSize + margin
            } else {
                maxX = nextX
            }
            self.addSubview(button)
        }
    }

    // MARK: Event

    @objc private func clickButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        button.backgroundColor = button.isSelected ? UIColor.orange1 : UIColor.white
    }

    // MARK:Tools
    private func createButton(_ letter: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor   = UIColor.white
        button.layer.borderColor = UIColor.hex(0xC0C0C0).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.setTitle(letter, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return button
    }

    /// 获得所有字母
    private func getAllLetters(_ rightRoutes: [Int]) -> [String] {
        let amount = itemNumberW * itemNumberH
        var tmpArray = [String]()
        for index in 0..<amount {
            if let offsetIndex = rightRoutes.firstIndex(of: index) {
                let letter = self.lettersArray[offsetIndex]
                tmpArray.append(letter)
            } else {
                let letter = self.getArcLetter()
                tmpArray.append(letter)
            }
        }
        return tmpArray
    }


    /// 获得一个随机字母,区分大小写
    private func getArcLetter() -> String {
        let lettersList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "y", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "Y", "V", "W", "X", "Y", "Z"]
        let index = Int(arc4random()) % lettersList.count
        let letter = lettersList[index]
        return letter
    }
}
