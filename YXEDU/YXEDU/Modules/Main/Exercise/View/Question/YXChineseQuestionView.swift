//
//  YXChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 中文词义题目
class YXChineseQuestionView: YXBaseQuestionView {

    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()

        self.spellView = YXSpellSubview(self.exerciseModel)
        addSubview(spellView!)

        self.initSubTitleLabel()
        subTitleLabel?.text = self.exerciseModel.subTitle
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let _spellView = spellView {
            let w = spellView?.wordViewList.last?.frame.maxX ?? CGFloat.zero
            _spellView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(topPadding)
                make.width.equalTo(w)
                make.height.equalTo(30)
            }
            subTitleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            })
        }
    }
    
    // MARK: YXAnswerEventProtocol
    override func clickWordButton(_ button: UIButton) {
        super.clickWordButton(button)
        if button.isSelected {
            self.spellView?.insertLetter(button)
        } else {
            self.spellView?.removeLetter(button)
        }
    }
}
