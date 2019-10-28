//
//  YXQuestionAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionAudioView: UIView {
    let audioButton: UIButton
    var delegate: YXQuestionEventProtocol?

    init(_ isShowBg: Bool = false) {
        audioButton = UIButton()
        var width   = CGFloat(22)
        var height  = CGFloat(22)

        if isShowBg {
            width  = 52
            height = 52
            audioButton.backgroundColor    = UIColor.hex(0xFFF4E9)
            audioButton.layer.cornerRadius = width/2
            audioButton.layer.borderWidth  = 3
            audioButton.layer.borderColor  = UIColor.hex(0xFFE8C5).cgColor
        } else {
            audioButton.backgroundColor = UIColor.white
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        audioButton.setImage(UIImage(named: "playAudioIcon"), for: .normal)
        audioButton.addTarget(self, action: #selector(clickAudioBtn(_:)), for: .touchUpInside)
        self.addSubview(audioButton)
        audioButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Event

    @objc func clickAudioBtn(_ button: UIButton) {
        button.isSelected = !button.isSelected
        delegate?.clickAudioButton(button)

//        if button.isSelected {
//            self.playAudio()
//        } else {
//            self.stopAudio()
//        }
    }

//    private func playAudio() {
//        while audioButton.isSelected {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.audioButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            }) { (finished) in
//                if finished {
//                    self.audioButton.transform = .identity
//                }
//            }
//        }
//
//    }
//
//    private func stopAudio() {
//        audioButton.transform = .identity
//    }


}
