//
//  YXQuestionSpellView.swift
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

class YXQuestionSpellView: UIView {
    let margin = CGFloat(10)
    let charH  = CGFloat(30)
    var maxX = CGFloat(0)
    var charModelsArray = [YXCharacterModel]()

    init(_ charModelsArray: [YXCharacterModel]) {
        super.init(frame: CGRect.zero)
        self.bindData(charModelsArray)
        let width = self.createUI()
        self.frame = CGRect(x: 0, y: 0, width: width, height: charH)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindData(_ charModelsArray: [YXCharacterModel]) {
        self.charModelsArray = charModelsArray
    }

    func createUI() -> CGFloat {
        maxX = 0
        for model in charModelsArray {
            let wordWidth = model.character.textWidth(font: UIFont.systemFont(ofSize: 20), height: charH) + margin
            let wordFrame = CGRect(x: maxX, y: 0, width: wordWidth, height: charH)
            let wordView  = YXWordCharacterView(frame: wordFrame)
            wordView.type = model.isBlank ? .blank : .normal
            wordView.textField.text = model.character
            self.addSubview(wordView)
            maxX += wordWidth + margin
        }
        return maxX - margin
    }
}