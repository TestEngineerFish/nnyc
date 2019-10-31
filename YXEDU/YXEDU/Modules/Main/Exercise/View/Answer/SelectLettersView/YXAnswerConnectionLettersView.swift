//
//  YXAnswerConnectionLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXAnswerConnectionLettersView: YXBaseAnswerView {

    var allButtonArray    = [UIButton]()
    var enableButtonArray = [UIButton]() // 可选按钮列表
    var selectedBtnArray  = [UIButton]() // 选中的按钮
    var lineDictionary    = [Int:CAShapeLayer]()
    var lastSelectedButton: UIButton? // 最后选中的按钮
    // 正确的字母路径
    var rightRoutes = [Int]()
    // 完整的字母
    var allLettersArray = [String]()
    // 正确的字母数组
    var lettersArray = [String]()
    var itemNumberH: Int
    var itemNumberW: Int
    let margin       = CGFloat(8)
    let itemSize     = CGFloat(48)
    // 是否大写
    var isCapitalLetter = false

    var util: YXFindRouteUtil?

    override init(exerciseModel: YXWordExerciseModel) {
        itemNumberH = exerciseModel.matix
        itemNumberW = exerciseModel.matix
        super.init(exerciseModel: exerciseModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindData() {
        super.bindData()
        self.lettersArray = self.exerciseModel.word.map { (char) -> String in
            return "\(char)"
        }
        // 查找最佳路径
        let matix = self.exerciseModel.matix
        self.util        = YXFindRouteUtil(matix, itemNumberW: matix)
        let startIndex   = Int(arc4random()) % (matix * matix)
        self.rightRoutes = util!.getRoute(start: startIndex, wordLength: lettersArray.count)
        self.allLettersArray = self.getAllLetters(rightRoutes)
    }

    override func createSubview() {
        super.createSubview()
        self.isCapitalLetter = self.justCapitalLetter(self.exerciseModel.word)
        self.createUI()
    }

    private func createUI() {
        allButtonArray = []
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
            allButtonArray.append(button)
        }
        // 显示首个字母的动画
        self.showFirstButtonAnimation(rightRoutes.first)
        // 添加手势事件
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan)
    }

    /// 在VC中显示的时候调用!!
    private func showFirstButtonAnimation(_ btnTag: Int?) {
        if let tag = btnTag, tag < self.allButtonArray.count, tag >= 0 {
            let button = self.allButtonArray[tag]
            self.selectedButton(button)
            button.layer.addBgFlickerAnimation(with: UIColor.orange1, repeat: 4)
        }
    }

    // MARK: Event

    @objc private func clickButton(_ button: UIButton) {
        if button.isEqual(self.selectedBtnArray.first) {
            return
        }
        if button.isEnabled {
            if button.isSelected {
                let reversedArray = self.selectedBtnArray.reversed()
                for btn in reversedArray {
                    self.unselectButton(btn)
                    if btn.tag == button.tag {
                        break
                    }
                }
            } else {
                self.selectedButton(button)
            }
        }
    }

    private func selectedButton(_ button: UIButton) {
        button.isSelected = true
        button.isEnabled  = true
        button.backgroundColor = UIColor.orange1
        button.layer.borderColor = UIColor.orange1.cgColor
        button.setTitleColor(UIColor.white, for: .selected)
        // 添加选中按钮
        if !self.selectedBtnArray.contains(button) {
            self.connectionLine(fromButton: self.selectedBtnArray.last, toButton: button)
            self.selectedBtnArray.append(button)
            // 震动效果
            if #available(iOS 10.0, *) {
                let shock = UIImpactFeedbackGenerator(style: .medium)
                shock.impactOccurred()
            }
        }
        // 更新周围可选按钮
        self.updateEnableButton(current: button)
    }

    private func unselectButton(_ button: UIButton) {
        button.isEnabled  = false
        button.isSelected = false
        button.backgroundColor =  UIColor.white
        button.layer.borderColor = UIColor.hex(0xC0C0C0).cgColor
        button.setTitleColor(UIColor.hex(0xC0C0C0), for: .normal)
        // 移除选中按钮
        guard let index = self.selectedBtnArray.firstIndex(of: button) else {
            return
        }
        self.selectedBtnArray.remove(at: index)
        // 移除连线
        self.disconectLine(button)
        // 震动效果
        if #available(iOS 10.0, *) {
            let shock = UIImpactFeedbackGenerator(style: .medium)
            shock.impactOccurred()
        }
        // 更新周围可选按钮
        self.updateEnableButton(current: self.selectedBtnArray.last)
    }

    private func updateEnableButton(current button: UIButton?){
        guard let _button = button else {
            return
        }
        // 移除上一次的可选按钮列表
        self.enableButtonArray.forEach { (btn) in
            if !self.selectedBtnArray.contains(btn) {
                btn.isEnabled = false
                btn.setTitleColor(UIColor.hex(0xC0C0C0), for: .normal)
            }
        }
        self.enableButtonArray = []
        // 获得最新的位置周边按钮
        let aroundButtons = util?.aroundIndexList(_button.tag)
        let newArray = aroundButtons?.compactMap({ (tag) -> UIButton? in
            let targetBtn = self.allButtonArray[tag]
            if self.selectedBtnArray.contains(targetBtn) {
                return nil
            } else {
                return targetBtn
            }
        })
        // 显示更新后的可选按钮
        newArray?.forEach({ (button) in
            button.isEnabled = true
            button.setTitleColor(UIColor.hex(0x323232), for: .normal)
        })
        guard let _newArray = newArray else {
            return
        }
        self.enableButtonArray = _newArray
    }

    /// 滑动事件
    @objc private func panEvent(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        // 检查是否在有效按钮区域中
        let selected = self.enableButtonArray.filter { (button) -> Bool in
            return button.frame.contains(point)
        }.first
        // 检查是否在上一个选中区域
        if let _selected = selected {
            self.selectedButton(_selected)
        } else if self.selectedBtnArray.count >= 2 {
            let previousButton = self.selectedBtnArray[self.selectedBtnArray.count - 2]
            if previousButton.frame.contains(point) {
                guard let lastBtn = self.selectedBtnArray.last else {
                    return
                }
                self.unselectButton(lastBtn)
            }
        }
    }

    /// 开始连线
    private func connectionLine(fromButton: UIButton?, toButton: UIButton) {
        guard let fromButton = fromButton else { return }
        let bezierPath = UIBezierPath()
        bezierPath.move(to: fromButton.center)
        bezierPath.addLine(to: toButton.center)
        let shaperLayer = CAShapeLayer()
        shaperLayer.path = bezierPath.cgPath
        shaperLayer.width = 1
        shaperLayer.strokeColor = UIColor.orange1.cgColor
        shaperLayer.fillColor = nil
        shaperLayer.zPosition = -1
        self.layer.addSublayer(shaperLayer)

        self.lineDictionary.updateValue(shaperLayer, forKey: toButton.tag)
    }

    // 取消连线
    private func disconectLine(_ button: UIButton) {
        guard let shaperLayer = self.lineDictionary[button.tag] else {
            return
        }
        shaperLayer.removeFromSuperlayer()
        self.lineDictionary.removeValue(forKey: button.tag)
    }

    //    private func showAroundButton(origin button: UIButton) ->

    // MARK:Tools
    private func createButton(_ letter: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor   = UIColor.white
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 19.2)
        button.layer.borderColor = UIColor.hex(0xC0C0C0).cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.setTitle(letter, for: .normal)
        button.setTitleColor(UIColor.hex(0xC0C0C0), for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return button
    }

    /// 获得所有字母
    private func getAllLetters(_ rightRoutes: [Int]) -> [String] {
        let letterArray  = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "y", "v", "w", "x", "y", "z"]
        let mingleArray2 = [["a", "e", "i", "o", "u"],["b", "p", "d", "g", "q"], ["c", "k", "t"], ["n", "l", "m"], ["f", "v", "w"], ["h", "r", "j", "y"], ["s", "z"]]
        let amount = itemNumberW * itemNumberH
        // 保护不可变内容(真实路径和混淆内容)
        var fixedlyLetters = self.rightRoutes
        var tmpArray = [String]()
        // 1、随机填充内容
        for _ in 0..<amount {
            let letter = self.getArcLetter(letterArray)
            tmpArray.append(letter)
        }
        // 2、将正确路径填充正确字母
        for index in 0..<self.rightRoutes.count {
            let rightIndex  = self.rightRoutes[index]
            let rightLetter = lettersArray[index]
            tmpArray[rightIndex] = rightLetter
            // 3、将混淆字母填充
            // 3.1、获取周围位置
            var aroundArray = util?.aroundIndexList(rightIndex)
            // 3.2、过滤得到有效位置
            aroundArray = aroundArray?.filter({ (index) -> Bool in
                return !fixedlyLetters.contains(index)
            })
            // 判断是否需要混淆
            for array in mingleArray2 {
                if array.contains(rightLetter) {
                    aroundArray?.forEach({ (index) in
                        // 3.3、获得对应混淆数组中随机数字(排除自己)
                        let letter = self.getArcLetter(array, exclusion: rightLetter)
                        tmpArray[index] = letter
                    })
                }
            }
            // 3.2.1、添加不可变内容
            fixedlyLetters += aroundArray ?? [Int]()
        }
        return tmpArray
    }

    /// 获得一个随机字母,区分大小写
    private func getArcLetter(_ array: [String], exclusion: String = "") -> String {
        var newArray = array
        if let exclusionIndex = newArray.firstIndex(of: exclusion) {
            newArray.remove(at: exclusionIndex)
        }
        let index = Int(arc4random()) % newArray.count
        var letter = newArray[index]
        if isCapitalLetter {
            letter = letter.capitalized
        } else {
            letter = letter.lowercased()
        }
        return letter
    }

    /// 是否全是大写
    private func justCapitalLetter(_ text: String) -> Bool {
        let regex = "^[A-Z]+$"
        let predicateRe = NSPredicate(format: "self matches %@", regex)
        return predicateRe.evaluate(with: text)
    }
}
