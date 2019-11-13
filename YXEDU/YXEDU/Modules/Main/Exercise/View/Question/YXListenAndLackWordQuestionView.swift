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
    var audioView: YXAudioPlayerView?

    override func createSubviews() {
        super.createSubviews()

        self.spellView = YXSpellSubview(self.exerciseModel)
        addSubview(spellView!)

        audioView = YXAudioPlayerView()
        addSubview(audioView!)
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
            audioView?.snp.makeConstraints({ (make) in
                make.top.equalTo(_spellView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(AdaptSize(22))
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
