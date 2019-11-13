//
//  YXAnswerConnectionLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 滑动(点击)连接字母答题页面
class YXAnswerConnectionLettersView: YXBaseAnswerView {

    var allButtonArray    = [YXLetterButton]()
    var enableButtonArray = [YXLetterButton]() // 可选按钮列表
    var selectedBtnArray  = [YXLetterButton]() // 选中的按钮
    var lineDictionary    = [Int:CAShapeLayer]()
    var lastSelectedButton: YXLetterButton? // 最后选中的按钮
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
    var word = ""

    var util: YXFindRouteUtil?

    override init(exerciseModel: YXWordExerciseModel) {
        itemNumberH = exerciseModel.question?.row ?? 0
        itemNumberW = exerciseModel.question?.column ?? 0
        super.init(exerciseModel: exerciseModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubview() {
        super.createSubview()
        self.setPath()
        self.isCapitalLetter = self.justCapitalLetter(self.word)
        self.createUI()
    }

    private func setPath() {
        guard let word = self.exerciseModel.word?.word else {
             return
         }
         self.lettersArray = word.map { (char) -> String in
             return "\(char)"
         }

         // 查找最佳路径
         self.util        = YXFindRouteUtil(itemNumberH, itemNumberW: itemNumberW)
         let startIndex   = Int.random(in: 0..<(itemNumberH * itemNumberW))
         self.rightRoutes = util!.getRoute(start: startIndex, wordLength: lettersArray.count)
         self.allLettersArray = self.getAllLetters(rightRoutes)
    }

    private func createUI() {
        allButtonArray = []
        selectedBtnArray = []
        var maxX = CGFloat.zero
        var maxY = CGFloat.zero
        let viewWidth = CGFloat(itemNumberW) * (itemSize + margin) - margin
        for index in 0..<allLettersArray.count {
            let letter = self.allLettersArray[index]
            let button = self.createButton(letter)
            button.tag = index
            button.frame = CGRect(x: maxX, y: maxY, width: itemSize, height: itemSize)
            let nextX = maxX + margin + itemSize
            if nextX > viewWidth {
                maxX = 0
                maxY += itemSize + margin
            } else {
                maxX = nextX
            }
            self.contentScrollView?.addSubview(button)
            allButtonArray.append(button)
        }
        // 显示首个字母的动画
        self.showFirstButtonAnimation(rightRoutes.first)
        // 添加手势事件
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan)
        self.contentScrollView?.contentSize = CGSize(width: viewWidth, height: viewWidth)
    }

    /// 在VC中显示的时候调用!!
    private func showFirstButtonAnimation(_ btnTag: Int?) {
        if let tag = btnTag, tag < self.allButtonArray.count, tag >= 0 {
            let button = self.allButtonArray[tag]
            self.selectedBtnArray.append(button)
            button.status = .selected
            // 更新周围可选按钮
            self.updateEnableButton(current: button)
            button.layer.addBgFlickerAnimation(with: UIColor.orange1, repeat: 4)
        }
    }

    // MARK: Event

    @objc private func clickButton(_ button: YXLetterButton) {
        if button.isEqual(self.selectedBtnArray.first) {
            return
        }
        if button.isEnabled {
            if button.status == .selected || button.status == .error {
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

    /// 选中按钮
    /// - Parameters:
    ///   - button: 目标按钮
    ///   - insert: 是否添加到问题区域
    /// - description:设置选中效果,需要满足,1、问题区域有空缺可填充(排除第一个字母);2、不在已选中列表中
    private func selectedButton(_ button: YXLetterButton) {

        let index = self.delegate?.selectedAnswerButton(button)
        // 添加按钮到已选按钮列表
        if index != nil, !self.selectedBtnArray.contains(button) {
            self.connectionLine(fromButton: self.selectedBtnArray.last, toButton: button)
            self.selectedBtnArray.append(button)
            button.status = .selected
            // 更新周围可选按钮
            self.updateEnableButton(current: button)
            if self.selectedBtnArray.count >= self.word.count {
                // 检查结果
                let errList = self.checkAnserResult()
                // 更新UI
                self.showResultView(errorList: errList)
                // 更新问题UI
                self.delegate?.showResult(errorList: errList)
            }
        }
    }
    /// 检查结果.如果有错误的则返回对应错误的ID数组,否则返回空数组
    private func checkAnserResult() -> [Int]{
        var errList = [Int]()
        for (index, letter) in word.enumerated() {
            let button = self.selectedBtnArray[index]
            if let text = button.currentTitle, text != "\(letter)" {
                errList.append(button.tag)
            }
        }
        return errList
    }

    /// 取消选中
    private func unselectButton(_ button: YXLetterButton) {
        self.delegate?.unselectAnswerButton(button)
        button.status = .disable
        // 移除选中按钮
        guard let index = self.selectedBtnArray.firstIndex(of: button) else {
            return
        }
        self.selectedBtnArray.remove(at: index)
        // 移除连线
        self.disconectLine(button)
        // 更新周围可选按钮
        self.updateEnableButton(current: self.selectedBtnArray.last)
    }

    private func updateEnableButton(current button: YXLetterButton?){
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
        let newArray = aroundButtons?.compactMap({ (tag) -> YXLetterButton? in
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
    private func connectionLine(fromButton: YXLetterButton?, toButton: YXLetterButton) {
        guard let fromButton = fromButton else { return }
        let bezierPath = UIBezierPath()
        bezierPath.move(to: fromButton.center)
        bezierPath.addLine(to: toButton.center)
        let shaperLayer         = CAShapeLayer()
        shaperLayer.path        = bezierPath.cgPath
        shaperLayer.lineWidth   = 6
        shaperLayer.fillColor   = nil
        shaperLayer.zPosition   = -1
        shaperLayer.strokeColor = UIColor.orange4.cgColor
        self.contentScrollView?.layer.addSublayer(shaperLayer)

        self.lineDictionary.updateValue(shaperLayer, forKey: toButton.tag)
        // 震动效果
        if #available(iOS 10.0, *) {
            let shock = UIImpactFeedbackGenerator(style: .medium)
            shock.impactOccurred()
        }
    }

    // 取消连线
    private func disconectLine(_ button: YXLetterButton) {
        guard let shaperLayer = self.lineDictionary[button.tag] else {
            return
        }
        shaperLayer.removeFromSuperlayer()
        self.lineDictionary.removeValue(forKey: button.tag)
        // 震动效果
        if #available(iOS 10.0, *) {
            let shock = UIImpactFeedbackGenerator(style: .medium)
            shock.impactOccurred()
        }
    }

    // MARK:Tools
    private func createButton(_ letter: String) -> YXLetterButton {
        let button = YXLetterButton()
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 19.2)
        button.status = .disable
        button.setTitle(letter, for: .normal)
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

    // TODO: YXQuestionEventProtocol


    private func showResultView(errorList list: [Int]) {
        if list.isEmpty {
            // 答题正确
            self.selectedBtnArray.forEach { (button) in
                button.status = .right
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, true)
        } else {
            for tag in list {
                if let button = self.selectedBtnArray.first(where: { (button) -> Bool in
                    return button.tag == tag
                }) {
                    button.status = .error
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, false)
        }
    }
}
