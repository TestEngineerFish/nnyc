//
//  YXGameAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameAnswerView: UIView {

    var selectedWordView = YXGameQuestionSubview()
    var answerView: YXAnswerConnectionLettersView?

    init() {
        super.init(frame: CGRect.zero)
        self.setSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ wordModel: YXGameWordModel) {
        self.selectedWordView.bindData(wordModel)
        var exerciseModel = YXWordExerciseModel()
        var questionModel = YXWordModel()
        questionModel.word     = wordModel.word
        questionModel.column   = wordModel.column
        questionModel.row      = wordModel.row
        exerciseModel.question = questionModel
        self.switchAnswerView(exerciseModel)
    }

    func setSubview() {
        let backgroundImageView = UIImageView(image: UIImage(named: "gameAnswerBackground"))
        self.addSubview(backgroundImageView)
        self.addSubview(selectedWordView)

        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        selectedWordView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(37))
            make.width.equalTo(selectedWordView.maxWidth)
        })

    }

    // MARK: ==== Tools ====
    private func switchAnswerView(_ exerciseModel: YXWordExerciseModel) {
        guard let wordModel = exerciseModel.question else {
            return
        }
        let answerViewSize = CGSize(width: AdaptSize(288), height: AdaptSize(288))
        let config = self.getConfig(wordModel: wordModel, answerViewSize: answerViewSize)
        answerView = YXAnswerConnectionLettersView(exerciseModel: exerciseModel, config: config)
        answerView?.delegate = selectedWordView
//        answerView?.answerDelegate = self
        self.addSubview(answerView!)
        answerView?.snp.remakeConstraints({ (make) in
            make.top.equalTo(selectedWordView.snp.bottom).offset(AdaptSize(18))
            make.centerX.equalToSuperview()
            make.size.equalTo(answerViewSize)
        })
    }

    private func getConfig(wordModel: YXWordModel, answerViewSize: CGSize) -> YXConnectionLettersConfig {

        var config = YXConnectionLettersConfig()
        config.itemMargin = AdaptSize(1)
        let w = (answerViewSize.width + config.itemMargin) / CGFloat(wordModel.column) - config.itemMargin
        let h = (answerViewSize.height + config.itemMargin) / CGFloat(wordModel.row) - config.itemMargin
        config.itemSize = CGSize(width: w, height: h)
        config.itemFont = UIFont.pfSCMediumFont(withSize: AdaptSize(24))
        config.itemBgImage = UIImage(named: "gameButtonNormal")
        config.backgroundNormalColor   = UIColor.clear
        config.backgroundSelectedColor = UIColor.clear
        config.backgroundErrorColor    = UIColor.clear
        config.backgroundRightColor    = UIColor.clear
        config.backgroundDisableColor  = UIColor.clear
        config.borderNormalColor       = UIColor.clear
        config.borderSelectedColor     = UIColor.clear
        config.borderRightColor        = UIColor.clear
        config.borderErrorColor        = UIColor.clear
        config.borderDisableColor      = UIColor.clear
        config.textNormalColor         = UIColor.hex(0x7F4722)
        config.textSelectedColor       = UIColor.hex(0xC75E19)
        config.textErrorColor          = UIColor.hex(0xD64A29)
        config.textRightColor          = UIColor.hex(0x347E3A)
        config.textDisableColor        = UIColor.hex(0x7F4722)
        return config
    }

    // MARK: ==== YXAnswerViewDelegate ====
//    func answerCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
//        print("answerCompletion")
//    }
//
//    func switchQuestionView() -> Bool {
//        print("switch")
//        return true
//    }

}
