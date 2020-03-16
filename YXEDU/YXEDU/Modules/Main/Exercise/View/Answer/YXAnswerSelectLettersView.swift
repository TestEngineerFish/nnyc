//
//  YXSelectLettersView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 选择字母答题页面
class YXAnswerSelectLettersView: YXBaseAnswerView, UITextFieldDelegate {

    let itemSize         = CGFloat(60)
    let margin           = CGFloat(10)
    let horItemNum       = 4
    var verItemNum       = 3
    var buttonArray2     = [[YXLetterButton]]()
    var selectedBtnArray = [YXLetterButton]()
    var textField        = UITextField()

    override func createSubviews() {
        super.createSubviews()
        guard let itemList = self.exerciseModel.option?.firstItems else {
            return
        }
        self.createButtonArray(itemList)
        self.createUI()
    }
    
    override func bindProperty() {
        if true {
            self.addSubview(textField)
            self.textField.delegate = self
            self.textField.keyboardType = .asciiCapable
            self.textField.becomeFirstResponder()
            self.isHidden = true
            NotificationCenter.default.addObserver(self, selector: #selector(showWordDetailView), name: YXNotification.kShowWordDetailPage, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hideWordDetailView), name: YXNotification.kCloseWordDetailPage, object: nil)
        } else {
            self.isHidden = false
        }
    }

    private func createUI() {
        var maxY = CGFloat(0)
        let contentView = UIView()
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
        self.addSubview(contentView)
        let contentViewH = CGFloat(buttonArray2.count) * (itemSize + margin) - margin
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(contentViewH)
        }
    }

    /// 根据单词数组,生成一行一组按钮的二维数组
    private func createButtonArray(_ itemList: [YXOptionItemModel]) {
        var wordsBtnArray2 = Array(repeating: [YXLetterButton](), count: 3)
        // 1、生成按钮组
        for (index, item) in itemList.enumerated() {
            let button = self.createWordButton(item.content)
            button.tag = index + offsetTag
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

        self.buttonArray2 = wordsBtnArray2.filter { (buttonList: [YXLetterButton]) -> Bool in
            return !buttonList.isEmpty
        }
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
    
    /// 显示单词详情提示
    @objc private func showWordDetailView() {
        self.textField.resignFirstResponder()
    }
    
    @objc private func hideWordDetailView() {
        self.textField.becomeFirstResponder()
    }

    @objc func clickButton(_ button: YXLetterButton) {
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
                    self.showResult(errorList: result.1)
                }
            }
        }
    }

    private func showResult(errorList list: [Int]) {
        self.isUserInteractionEnabled = false
        if list.isEmpty {
            // 答题正确
//            self.selectedBtnArray.forEach { (button) in
//                button.status = .right
//            }
            // 如果是Q-B-1，则需要播放语音
//            if self.exerciseModel.type == .fillWordAccordingToChinese, let urlStr = self.exerciseModel.word?.voice, let url = URL(string: urlStr) {
//                YXAVPlayerManager.share.playAudio(url) { [weak self] in
//                    guard let self = self else {return}
//                    YXAVPlayerManager.share.finishedBlock = nil
//                    self.answerDelegate?.answerCompletion(self.exerciseModel, true)
//                }
//            } else {
            self.textField.resignFirstResponder()
            self.answerDelegate?.answerCompletion(self.exerciseModel, true)
//            }
        } else {
            if true {
                self.isUserInteractionEnabled = true
            } else {
                // 答题错误
                self.selectedBtnArray.forEach { (letterBtn) in
                    if list.contains(letterBtn.tag) {
                        letterBtn.status = .error
                    }
                    // 取消选中状态
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                        // 反之用户在这之间已取消选中
                        if letterBtn.status != .normal && letterBtn.status != .disable {
                            self.clickButton(letterBtn)
                        }
                        self.isUserInteractionEnabled = true
                    }
                }
            }
            self.answerDelegate?.answerCompletion(self.exerciseModel, false)
        }
    }
    
    // MARK: ---- UITextFieldDelegate ----
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let button    = YXLetterButton()
        button.text   = string
        button.status = .normal
        if range.length > 0 {
            self.delegate?.unselectAnswerButton(button)
        } else {
            let success = delegate?.selectedAnswerButton(button) ?? false
            if success, let result = self.delegate?.checkResult(), result.0 {
                self.showResult(errorList: result.1)
            }
        }
        return true
    }
}
