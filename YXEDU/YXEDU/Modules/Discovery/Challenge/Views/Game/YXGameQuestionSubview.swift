//
//  YXGameQuestionSubview.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameQuestionSubview: UIView, YXAnswerEventProtocol {


    var wordLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0xC9823D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(20))
        label.textAlignment = .center
        return label
    }()
    var wordModel: YXGameWordModel?
    var selectedButtonList = [YXLetterButton]()
    final let maxWidth = AdaptSize(162)
    weak var vcDelegate: YXGameViewControllerProtocol?

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor    = UIColor.hex(0xFAD8B7)
        self.layer.cornerRadius = AdaptSize(8)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ wordModel: YXGameWordModel) {
        selectedButtonList  = []
        self.wordLabel.text = ""
        self.wordModel      = wordModel
    }

    private func createSubviews() {
        self.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.bottom.equalToSuperview()
        }
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let labelWidth = (self.wordLabel.text ?? "").textWidth(font: wordLabel.font, height: self.height)
        let w = labelWidth + AdaptSize(30) > maxWidth ? labelWidth + AdaptSize(30) : maxWidth
        if self.superview != nil {
            self.snp.updateConstraints { (make) in
                make.width.equalTo(AdaptSize(w))
            }
        }
    }
    // MARK: ==== Event ====
    private func showReuslt(_ success: Bool) {
        if success {
            YXAVPlayerManager.share.playRightAudio()
            self.wordLabel.textColor = UIColor.hex(0x5E9E63)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.vcDelegate?.switchQuestion()
            }
        } else {
            YXAVPlayerManager.share.playWrongAudio()
            self.wordLabel.textColor = UIColor.hex(0xFF532B)
        }
    }

    // MARK: ==== YXAnswerEventProtocol ====

    func selectedAnswerButton(_ button: YXLetterButton) -> Bool {
        guard let wordModel = self.wordModel else {
            return false
        }
        self.wordLabel.textColor = UIColor.hex(0xC9823D)
        var lackWord = self.wordLabel.text ?? ""
        if lackWord.count >= wordModel.word.count {
            return false
        } else {
            lackWord += button.currentTitle ?? ""
            self.wordLabel.text = lackWord
            self.selectedButtonList.append(button)
            self.layoutIfNeeded()
            return true
        }
    }

    func unselectAnswerButton(_ button: YXLetterButton) {
        if self.selectedButtonList.isEmpty {
            return
        }
        var lackWord = self.wordLabel.text ?? ""
        lackWord.removeLast()
        self.wordLabel.text = lackWord
        self.selectedButtonList.removeLast()
        self.layoutIfNeeded()
    }
    func playAudio() {}

    func checkResult() -> (Bool, [Int])? {
        guard let wordModel = self.wordModel else {
            return nil
        }
        let currentText = self.wordLabel.text ?? ""
        var isShow = false
        var errorList = [Int]()
        if currentText.count >= wordModel.word.count {
            isShow = true
            for (index, char) in wordModel.word.enumerated() {
                if index < self.selectedButtonList.count {
                    let selectedBtn = selectedButtonList[index]
                    let selectedStr = selectedBtn.currentTitle ?? ""
                    if selectedStr != "\(char)" {
                        errorList.append(selectedBtn.tag)
                    }
                }
            }
        }
        if isShow {
            self.showReuslt(errorList.isEmpty)
        }

        return (isShow, errorList)
    }


}
