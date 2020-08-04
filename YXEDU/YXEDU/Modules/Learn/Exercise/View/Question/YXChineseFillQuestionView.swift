//
//  YXChineseFillQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChineseFillQuestionView: YXBaseQuestionView {

    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()

        self.spellView = YXSpellSubview(self.exerciseModel, isTitle: true)
        addSubview(spellView!)

        self.initSubTitleLabel()
    }

    override func bindData() {
        super.bindData()
        guard let property = self.exerciseModel.word?.partOfSpeech, let meaning = self.exerciseModel.word?.meaning else {
            return
        }
        self.subTitleLabel?.text = property + meaning
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let _spellView = spellView {
            let w = _spellView.maxX - _spellView.margin
            _spellView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(topPadding)
                make.width.equalTo(w)
                make.height.equalTo(AdaptIconSize(30))
            }
            subTitleLabel?.snp.remakeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(AdaptIconSize(10))
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            })
        }
    }
    
    // MARK: YXAnswerEventProtocol
    override func selectedAnswerButton(_ button: YXLetterButton) -> Bool {
        return self.spellView?.insertLetter(button) ?? false
    }

    override func unselectAnswerButton(_ button: YXLetterButton) {
        self.spellView?.removeLetter(button)
    }
    
    override func checkResult() -> (Bool, [Int])? {
        return self.spellView?.checkResult()
    }

}
