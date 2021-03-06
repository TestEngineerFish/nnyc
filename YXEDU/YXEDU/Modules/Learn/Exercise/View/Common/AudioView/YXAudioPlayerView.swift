//
//  YXQuestionAudioView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


protocol YXAudioPlayerViewDelegate: NSObjectProtocol {
    ///  播放开始
    func playAudioStart()
    /// 播放结束
    func playAudioFinished()
}

extension YXAudioPlayerViewDelegate {
    func playAudioStart() {}
}

class YXAudioPlayerView: UIView {
    weak var delegate: YXAudioPlayerViewDelegate?
    
    private let audioButton: UIButton
    var urlStr: String?
    var urlStrList = [String]()
    var hasPermissions = true

    init() {
        self.audioButton = UIButton()
        self.audioButton.imageView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        super.init(frame: CGRect(x: 0, y: 0, width: AdaptIconSize(22), height: AdaptIconSize(22)))
        audioButton.setImage(UIImage(named: "playAudioIcon"), for: .normal)
        audioButton.addTarget(self, action: #selector(clickAudioBtn), for: .touchUpInside)
        self.addSubview(audioButton)
        audioButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 判断权限
        YXAuthorizationManager.authorizeMicrophoneWith { (isAllow) in
            self.hasPermissions = isAllow
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 播放当前音频
    func play() {
        guard let _urlStr = self.urlStr, let url = URL(string: _urlStr) else {
            YXLog("无效的音频地址: \(String(describing: self.urlStr))")
            YXUtils.showHUD(nil, title: "无效音频")
            return
        }
        self.audioButton.layer.addFlickerAnimation()
        if YXAVPlayerManager.share.isPlaying {
            YXAVPlayerManager.share.pauseAudio()
        }
        self.delegate?.playAudioStart()
        YXAVPlayerManager.share.playAudio(url) { [weak self] in
            guard let self = self else { return }
            self.delegate?.playAudioFinished()
            self.audioButton.layer.removeFlickerAnimation()
        }
    }
    
    /// 播放一组音频
    func playList() {
        if !YXAVPlayerManager.share.isPlaying {
            self.audioButton.layer.addFlickerAnimation()
        }
        YXAVPlayerManager.share.playListAudio(self.urlStrList) { [weak self] in
            guard let self = self else { return }
            self.audioButton.layer.removeFlickerAnimation()
        }
    }

    // TODO: Event

    @objc func clickAudioBtn() {
        self.play()
    }

}
