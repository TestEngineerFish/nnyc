//
//  YXWordAndImageQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 图片+单词+音标题目
class YXWordAndImageQuestionView: YXBaseQuestionView {

    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()
        self.initImageView()
        self.spellView = YXSpellSubview(self.exerciseModel)
        addSubview(spellView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _spellView = spellView {
            let w = _spellView.maxX - _spellView.margin
            _spellView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(topPadding)
                make.width.equalTo(w)
                make.height.equalTo(30)
            }
            imageView?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.width.equalTo(130)
                make.height.equalTo(94)
            })
        }
    }

    // MARK: YXAnswerEventProtocol
    override func selectedAnswerButton(_ button: YXLetterButton) -> Int {
        return self.spellView?.insertLetter(button) ?? 0
    }

    override func unselectAnswerButton(_ button: YXLetterButton) {
        self.spellView?.removeLetter(button)
    }

    override func showResult(errorList list: [Int]) {
        self.spellView?.showResultView(errorList: list)
    }
}

