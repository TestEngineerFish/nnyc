//
//  YXListenAndLackWordQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/2.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

/// 填词 + 语音
class YXListenAndLackWordQuestionView: YXBaseQuestionView {

    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()

        self.spellView = YXSpellSubview(self.exerciseModel, isTitle: true)
        self.spellView?.backgroundColor = UIColor.yellow
        addSubview(spellView!)

        self.initAudioPlayerView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let _spellView = spellView {
            let w = _spellView.maxX - _spellView.margin
            _spellView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(topPadding)
                make.width.equalTo(w)
                make.height.equalTo(AdaptSize(28))
            }
            audioPlayerView?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(AdaptSize(32))
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
