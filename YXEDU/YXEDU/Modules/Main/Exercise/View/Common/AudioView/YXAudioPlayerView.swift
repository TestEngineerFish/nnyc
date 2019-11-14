//
//  YXQuestionAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


protocol YXAudioPlayerViewDelegate {
    ///  播放开始
    func playAudioStart()
    /// 播放结束
    func playAudioFinished()
}

class YXAudioPlayerView: UIView {
    var delegate: YXAudioPlayerViewDelegate?
    
    private let audioButton: UIButton
    var urlStr: String?

    init() {
        self.audioButton = UIButton()
        self.audioButton.imageView?.snp.makeConstraints({ (make) in
            make.left.top.equalToSuperview().offset(3)
            make.bottom.right.equalToSuperview().offset(-3)
        })
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(22), height: CGFloat(22)))
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
    
    /// 播放当前音频
    func play() {
        guard let _urlStr = self.urlStr, let url = URL(string: _urlStr) else {
            print("无效的音频地址: \(String(describing: self.urlStr))")
            return
        }
        if !YXAVPlayerManager.share.isPlaying {
            self.audioButton.layer.addFlickerAnimation()
        }
        self.delegate?.playAudioStart()
        YXAVPlayerManager.share.playerAudio(url) {
            self.delegate?.playAudioFinished()
            self.audioButton.layer.removeFlickerAnimation()
        }
    }

    // TODO: Event

    @objc func clickAudioBtn() {
        self.play()
    }

}
