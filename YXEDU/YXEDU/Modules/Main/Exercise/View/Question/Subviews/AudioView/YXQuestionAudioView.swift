//
//  YXQuestionAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXQuestionAudioSubview: UIView {
    let audioButton = UIButton()
    var exerciseModel: YXWordExerciseModel
    var delegate: YXQuestionEventProtocol?

    init(exerciseModel: YXWordExerciseModel,isShowBg: Bool = false) {
        self.exerciseModel = exerciseModel

        var width   = CGFloat(22)
        var height  = CGFloat(22)
        if isShowBg {
            width  = 52
            height = 52
            audioButton.backgroundColor    = UIColor.orange3
            audioButton.layer.cornerRadius = width/2
            audioButton.layer.borderWidth  = 3
            audioButton.layer.borderColor  = UIColor.orange2.cgColor
        } else {
            audioButton.backgroundColor = UIColor.white
            audioButton.imageView?.snp.makeConstraints({ (make) in
                make.left.top.equalToSuperview().offset(3)
                make.bottom.right.equalToSuperview().offset(-3)
            })
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        audioButton.setImage(UIImage(named: "playAudioIcon"), for: .normal)
        audioButton.addTarget(self, action: #selector(clickAudioBtn), for: .touchUpInside)
        self.addSubview(audioButton)
        audioButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Event

    @objc func clickAudioBtn() {
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
            self.audioButton.layer.removeFlickerAnimation()
        } else {
            guard let path = Bundle.main.path(forResource: "right", ofType: "mp3") else {
                return
            }
            let url = URL(fileURLWithPath: path)
            self.audioButton.layer.addFlickerAnimation()
            YXAVPlayerManager.share.playerAudio(url) {
                self.delegate?.endPlayAudio()
                self.audioButton.layer.removeFlickerAnimation()
            }
        }
    }

}
