//
//  YXSpellSubview.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import SnapKit

struct YXCharacterModel {
    var character: String
    var isBlank: Bool
    init(_ char: String, isBlank: Bool) {
        self.character = char
        self.isBlank = isBlank
    }
}

class YXSpellSubview: UIView {
    let margin = CGFloat(10)
    let charH  = CGFloat(30)

    var exerciseModel: YXWordExerciseModel
    var wordViewList = [YXWordCharacterView]()

    /// 点击已填充字母的空.回调闭包
    var removeLetter: ((Int)->Void)?
    var result: (([Int])->Void)?

    init(_ model: YXWordExerciseModel) {
        self.exerciseModel = model
        super.init(frame: CGRect.zero)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
        var maxX = CGFloat(0)
        wordViewList = []
        for index in 0..<self.exerciseModel.charModelArray.count {
            let model = self.exerciseModel.charModelArray[index]
            let wordWidth = model.character.textWidth(font: UIFont.pfSCSemiboldFont(withSize: 20), height: charH) + margin
            let wordFrame = CGRect(x: maxX, y: 0, width: wordWidth, height: charH)
            let wordView  = YXWordCharacterView(frame: wordFrame)
            wordView.tag = index
            if model.isBlank {
               wordView.textField.text = ""
                wordView.status = .blank
            } else {
                wordView.textField.text = model.character
                wordView.status = .normal
            }
            self.addSubview(wordView)
            self.wordViewList.append(wordView)
            maxX += wordWidth + margin
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapWordView(_:)))
            wordView.addGestureRecognizer(tap)
        }
        return
    }

    @objc private func tapWordView(_ tap: UITapGestureRecognizer) {
        guard let wordCharView = tap.view as? YXWordCharacterView else {
            return
        }
        if wordCharView.status != .normal, !wordCharView.text.isNilOrEmpty {
            wordCharView.text = ""
            wordCharView.status = .blank
            self.removeLetter?(wordCharView.tag)
        }
    }

    // TODO: Event

    /// 添加单词
    func insertLetter(_ button: YXLetterButton) -> Bool {
        for wordView in self.wordViewList {
            if wordView.text.isNilOrEmpty {
                wordView.text = button.currentTitle
                wordView.tag  = button.tag
                return true
            }
        }
        return false
    }

    /// 移除单词
    func removeLetter(_ button: YXLetterButton) {
        for wordView in self.wordViewList {
            if wordView.tag == button.tag {
                wordView.text = ""
                wordView.status = .blank
            }
        }
    }

    // TODO: Tools
    /// 检查结果
    /// - description: 如果有错误的单词,则通过tag传递给答题视图
    func startCheckResult() {
        let lackWord = self.wordViewList.filter { (wordView) -> Bool in
            return wordView.text.isNilOrEmpty
        }
        // 如果有未填写完整的内容,则不检查
        if !lackWord.isEmpty {
            return
        }
        var errorTags = [Int]()
        for index in 0..<self.wordViewList.count {
            if index >= self.exerciseModel.charModelArray.count {
                return
            }
            let rightWord   = self.exerciseModel.charModelArray[index]
            let currentWord = self.wordViewList[index]
            if rightWord.character != (currentWord.text ?? "") {
                errorTags.append(currentWord.tag)
                currentWord.status = .error
            }
        }
        self.result?(errorTags)
    }
}
