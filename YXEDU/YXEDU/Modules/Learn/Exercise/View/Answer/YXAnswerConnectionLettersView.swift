//
//  YXAnswerConnectionLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXConnectionLettersConfig {
    var itemSize   = CGSize(width: AdaptSize(isPad() ? 90 : 48), height: AdaptSize(isPad() ? 90 : 48))
    var itemMargin = AdaptSize(isPad() ? 15 : 8)
    var itemFont = UIFont.pfSCRegularFont(withSize: AdaptFontSize(20))
    var backgroundNormalImage: UIImage?   = nil
    var backgroundSelectedImage: UIImage? = nil
    var backgroundErrorImage: UIImage?    = nil
    var backgroundRightImage: UIImage?    = nil
    var backgroundDisableImage: UIImage?  = nil
    var backgroundNormalColor   = UIColor.white
    var backgroundSelectedColor = UIColor.orange1
    var backgroundErrorColor    = UIColor.white
    var backgroundRightColor    = UIColor.white
    var backgroundDisableColor  = UIColor.white
    var borderNormalColor       = UIColor.black6
    var borderSelectedColor     = UIColor.orange1
    var borderErrorColor        = UIColor.red1
    var borderRightColor        = UIColor.green1
    var borderDisableColor      = UIColor.black6
    var textNormalColor         = UIColor.black1
    var textSelectedColor       = UIColor.white
    var textErrorColor          = UIColor.red1
    var textRightColor          = UIColor.green1
    var textDisableColor        = UIColor.black6

    var showFirstButton  = true
    var initButtonStatus = YXWordButtonStatus.disable
    var showAllRightView = false
    var showAllErrorView = false
    var resultAnimationTime = Double(3.0)
}

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
    var config: YXConnectionLettersConfig

    // 是否大写
    var isCapitalLetter = false
    var word = ""
    
    var util: YXFindRouteUtil?
    var pan: UIPanGestureRecognizer?

    init(exerciseModel: YXExerciseModel, config: YXConnectionLettersConfig = YXConnectionLettersConfig()) {
        itemNumberH = exerciseModel.question?.extendModel?.row ?? 0
        itemNumberW = exerciseModel.question?.extendModel?.column ?? 0
        self.config = config
        super.init(exerciseModel: exerciseModel)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.setPath()
        self.isCapitalLetter = self.justCapitalLetter(self.word)
        self.createUI()
    }
    
    private func setPath() {
        guard var word = self.exerciseModel.question?.word, itemNumberH != 0 && itemNumberW != 0 else {
            return
        }
        word = word.replacingOccurrences(of: "[", with: "")
        word = word.replacingOccurrences(of: "]", with: "")
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
        allButtonArray   = []
        selectedBtnArray = []
        var maxX = CGFloat.zero
        var maxY = CGFloat.zero
        let viewWidth = CGFloat(itemNumberW) * (config.itemSize.width + config.itemMargin) - config.itemMargin
        for index in 0..<allLettersArray.count {
            let letter = self.allLettersArray[index]
            let button = self.createButton(letter)
            button.tag = index
            button.frame = CGRect(x: maxX, y: maxY, width: config.itemSize.width, height: config.itemSize.height)
            let nextX = maxX + config.itemMargin + config.itemSize.width
            if nextX > viewWidth {
                maxX = 0
                maxY += config.itemSize.height + config.itemMargin
            } else {
                maxX = nextX
            }
            self.addSubview(button)
            allButtonArray.append(button)
        }
        // 显示首个字母的动画
        if config.showFirstButton {
            self.showFirstButtonAnimation(rightRoutes.first)
        }
        // 添加手势事件
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan!)
    }
    
    /// 显示首个字母动画
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

        if button.status != .disable {
            if self.selectedBtnArray.contains(button) {
                let reversedArray = self.selectedBtnArray.reversed()
                for btn in reversedArray {
                    // 如果选中首字母,则跳出
                    if btn.isEqual(self.selectedBtnArray.first) && config.showFirstButton {
                        break
                    }
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
        // 如果选中了一个,则更新其他按钮为不可选中
        if selectedBtnArray.isEmpty {
            self.allButtonArray.forEach { (letterButton) in
                letterButton.status = .disable
            }
        }
        // 通过回调更新选中顺序,也可防止同时选中多个
        let success = delegate?.selectedAnswerButton(button) ?? false
        if !self.selectedBtnArray.contains(button) && success {
            // 连线
            self.connectionLine(fromButton: self.selectedBtnArray.last, toButton: button)
            // 添加到已选数组
            self.selectedBtnArray.append(button)
            button.status = .selected
            // 更新周围可选按钮
            self.updateEnableButton(current: button)
            
            if let result = self.delegate?.checkResult(), result.0 {
                self.showResult(errorList: result.1)
            }
        }
    }
    
    /// 取消选中
    private func unselectButton(_ button: YXLetterButton) {
        self.delegate?.unselectAnswerButton(button)
        button.status = config.initButtonStatus
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
            self.allButtonArray.forEach { (button) in
                button.status = .normal
            }
            YXLog("移除了最后一个已选按钮")
            return
        }
        // 移除上一次的可选按钮列表
        self.enableButtonArray.forEach { (btn) in
            if !self.selectedBtnArray.contains(btn) {
                btn.status = .disable
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
            button.status = .normal
        })
        self.enableButtonArray = newArray ?? []
    }
    
    /// 滑动事件
    @objc private func panEvent(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self)
        var selected: YXLetterButton?
        if self.selectedBtnArray.isEmpty {
            selected = self.allButtonArray.filter({ (button) -> Bool in
                return button.frame.contains(point)
                }).first
        } else {
            // 检查是否在有效按钮区域中
            selected = self.enableButtonArray.filter { (button) -> Bool in
                return button.frame.contains(point)
            }.first
        }
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
        shaperLayer.lineWidth   = AdaptIconSize(6)
        shaperLayer.fillColor   = nil
        shaperLayer.zPosition   = -1
        shaperLayer.strokeColor = UIColor.orange4.cgColor
        self.layer.addSublayer(shaperLayer)
        
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
        let button = YXLetterButton(config: config)
        button.status = config.initButtonStatus
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
                if array.contains(rightLetter.lowercased()) {
                    aroundArray?.forEach({ (index) in
                        // 3.3、获得对应混淆数组中随机数字(排除自己)
                        var letter = self.getArcLetter(array, exclusion: rightLetter)
                        if self.justCapitalLetter(rightLetter) {
                            letter = letter.uppercased()
                        }
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
        let index = Int.random(in: 0..<newArray.count)
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
    
    private func showResult(errorList list: [Int]) {
        // 防止显示结果后,手势依旧在处理滑动事件
        if let pan = self.pan {
            self.removeGestureRecognizer(pan)
        }
        if list.isEmpty {
            // 答题正确
            if config.showAllRightView {
                self.selectedBtnArray.forEach { (letterBtn) in
                    // 变更连线颜色
                    let shaperLayer = self.lineDictionary[letterBtn.tag]
                    shaperLayer?.strokeColor = config.textRightColor.cgColor
                    letterBtn.status = .right
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, true)
        } else {
            // 答题错误
            self.selectedBtnArray.forEach { (letterBtn) in
                // 变更连线颜色
                let shaperLayer = self.lineDictionary[letterBtn.tag]
                shaperLayer?.strokeColor = UIColor.red1.cgColor
                if config.showAllErrorView {
                    letterBtn.status = .error
                } else {
                    if list.contains(letterBtn.tag) {
                        letterBtn.status = .error
                    }
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, false)
        }
        if let button = self.selectedBtnArray.first {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + config.resultAnimationTime) {
                self.clickButton(button)
                if !self.config.showFirstButton {
                    self.allButtonArray.forEach { (letterButton) in
                        letterButton.status = self.config.initButtonStatus
                    }
                }
            }
        }
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan!)
    }
}
