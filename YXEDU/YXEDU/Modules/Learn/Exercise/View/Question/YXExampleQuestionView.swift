//
//  YXExampleQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 例句题目
class YXExampleQuestionView: YXBaseQuestionView, YXAudioPlayerViewDelegate {
    
    private var audioList: [String] = []
    
    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.titleLabel?.font = UIFont.pfSCMediumFont(withSize: AdaptFontSize(20))
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.snp.remakeConstraints({ (make) in
            let height = self.titleLabel?.attributedText?.string.textHeight(font: titleLabel?.font ?? UIFont.pfSCSemiboldFont(withSize: AdaptFontSize(26)), width: self.width - AdaptSize(60)) ?? 0
            make.centerY.equalToSuperview()
            make.left.equalTo(AdaptSize(30))
            make.right.equalTo(AdaptSize(-30))
            make.height.equalTo(height)
        })
    }
    
    override func bindProperty() {
        self.audioPlayerView?.isHidden = true
        self.audioPlayerView?.delegate = self
    }
    
    override func bindData() {
        self.titleLabel?.attributedText = exerciseModel.word?.examples?.first?.englishExampleAttributedString
        
        self.audioList.append(self.exerciseModel.word?.voice ?? "")
        self.audioList.append(self.exerciseModel.word?.examples?.first?.vocie ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.playAudio()
        }
    }
    
    deinit {
        YXAVPlayerManager.share.pauseAudio()
    }
    
    /// 播放语音
    override func playAudio() {
        if !audioList.isEmpty {
            self.audioPlayerView?.urlStrList = self.audioList
            self.audioPlayerView?.playList()
        }
    }
    
    func playAudioFinished() {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.audioPlayerView?.urlStr = self.exerciseModel.word?.voice
        self.audioPlayerView?.play()
    }
}
