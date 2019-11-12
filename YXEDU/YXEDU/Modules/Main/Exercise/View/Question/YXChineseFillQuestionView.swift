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

        self.spellView = YXSpellSubview(self.exerciseModel)
        addSubview(spellView!)

        self.initSubTitleLabel()
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
            subTitleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            })
        }
    }
    
    
    override func bindData() {
//        self.subTitleLabel?.text = exerciseModel.question?.paraphrase
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
