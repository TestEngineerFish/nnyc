//
//  YXGameQuestionSubview.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameQuestionSubview: UIView, YXAnswerEventProtocol {

    // =============如果内容超过当前默认宽度162.(左右边距15),则动态变宽
    //
    var wordLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0xC9823D)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(20))
        label.textAlignment = .center
        return label
    }()
    var wordModel: YXGameWordModel?
    final let maxWidth = AdaptSize(162)

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
        self.wordModel = wordModel
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
        self.wordLabel.sizeToFit()
        let w = self.wordLabel.width + AdaptSize(30) > maxWidth ? self.wordLabel.width + AdaptSize(30) : maxWidth
        print(w)
        if self.superview != nil {
            self.snp.updateConstraints { (make) in
                make.width.equalTo(AdaptSize(w))
            }
        }
    }

    // MARK: ==== YXAnswerEventProtocol ====

    func selectedAnswerButton(_ button: YXLetterButton) -> Bool {
        guard let wordModel = self.wordModel else {
            return false
        }
        var lackWord = self.wordLabel.text ?? ""
        lackWord += button.currentTitle ?? ""
        self.wordLabel.text = lackWord
        self.layoutIfNeeded()
        if lackWord.count > wordModel.word.count {
            return false
        } else {
            return true
        }
    }
    func unselectAnswerButton(_ button: YXLetterButton) {
        var lackWord = self.wordLabel.text ?? ""
        lackWord.removeLast()
        self.wordLabel.text = lackWord
        self.setNeedsLayout()
    }
    func playAudio() {}

    func checkResult() -> (Bool, [Int])? {
        print("看看结果")
        return nil
    }


}
