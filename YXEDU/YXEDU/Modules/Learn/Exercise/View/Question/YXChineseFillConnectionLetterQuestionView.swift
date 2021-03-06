//
//  YXChineseFillConnectionLetterQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChineseFillConnectionLetterQuestionView: YXBaseQuestionView {
    var spellView: YXSpellSubview?

    override func createSubviews() {
        super.createSubviews()

        self.initTitleLabel()
        self.titleLabel?.font = UIFont.semiboldFont(ofSize: AdaptFontSize(20))
        self.initAudioPlayerView()

        self.spellView = YXSpellSubview(self.exerciseModel, isTitle: false)
        addSubview(spellView!)
    }

    override func bindData() {
        super.bindData()
        guard let property = self.exerciseModel.word?.partOfSpeech, let meaning = self.exerciseModel.word?.meaning else {
            return
        }
        self.titleLabel?.text = property + meaning
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.audioPlayerView?.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.titleLabel != nil {
            self.titleLabel?.sizeToFit()
            self.titleLabel?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(AdaptSize(36))
                make.height.equalTo(AdaptIconSize(30))
                make.width.equalTo(self.titleLabel!.width)
            })
            self.audioPlayerView?.snp.makeConstraints({ (make) in
                make.left.equalTo(self.titleLabel!.snp.right).offset(AdaptIconSize(3))
                make.centerY.equalTo(self.titleLabel!)
                make.size.equalTo(CGSize(width: AdaptIconSize(22), height: AdaptIconSize(22)))
            })
            let spellViewW = (self.spellView?.maxX ?? 0) - (self.spellView?.margin ?? 0)
            self.spellView?.snp.makeConstraints({ (make) in
                make.top.equalTo(self.titleLabel!.snp.bottom).offset(AdaptIconSize(10))
                make.centerX.equalToSuperview()
                make.width.equalTo(spellViewW)
                make.height.equalTo(AdaptIconSize(22))
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
