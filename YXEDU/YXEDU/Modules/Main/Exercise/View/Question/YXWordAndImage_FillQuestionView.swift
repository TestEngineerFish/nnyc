//
//  YXWordAndImage_FillQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordAndImage_FillQuestionView: YXBaseQuestionView {

    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()
        
        self.spellView = YXSpellSubview(self.exerciseModel, isTitle: true)
        addSubview(spellView!)

        self.initImageView()
    }

    override func bindData() {
        super.bindData()
        guard let imageUrl = self.exerciseModel.word?.imageUrl else {
            return
        }
        self.imageView?.showImage(with: imageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _spellView = spellView {
            let w = _spellView.maxX - _spellView.margin
            _spellView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(topPadding)
                make.width.equalTo(w)
                make.height.equalTo(AdaptIconSize(30))
            }
            imageView?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(AdaptIconSize(10))
                make.centerX.equalToSuperview()
                make.width.equalTo(AdaptIconSize(130))
                make.height.equalTo(AdaptIconSize(94))
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
