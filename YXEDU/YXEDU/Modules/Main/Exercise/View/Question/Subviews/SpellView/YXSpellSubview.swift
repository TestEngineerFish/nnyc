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
                wordView.type = .blank
            } else {
                wordView.textField.text = model.character
                wordView.type = .normal
            }
            self.addSubview(wordView)
            self.wordViewList.append(wordView)
            maxX += wordWidth + margin
        }
        return
    }

    /// 添加单词
    func insertLetter(_ button: UIButton) {
        for wordView in self.wordViewList {
            if wordView.textField.text == "" ||  wordView.textField.text == nil {
                wordView.textField.text = button.currentTitle
                wordView.textField.tag  = button.tag
                return
            }
        }
    }

    /// 移除单词
    func removeLetter(_ button: UIButton) {
        for wordView in self.wordViewList {
            if wordView.textField.tag == button.tag {
                wordView.textField.text = ""
            }
        }
    }

    /// 验证结果,是否正确
//    private func checkResult() {
//        var result = true
//        for index in 0..<self.exerciseModel.charModelArray.count {
//            let rightModel = self.exerciseModel.charModelArray[index]
//            let currentWordView = self.wordViewList[index]
//            if rightModel.character != currentWordView.textField.text ?? "" {
//                currentWordView.type = .error
//                result = false
//            }
//        }
//    }
}
