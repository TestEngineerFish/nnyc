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
        self.titleLabel?.font = UIFont.pfSCMediumFont(withSize: AdaptSize(20))
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.snp.remakeConstraints({ (make) in
            let height = self.titleLabel?.attributedText?.string.textHeight(font: titleLabel!.font, width: self.width - AdaptSize(60)) ?? 0
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
        self.titleLabel?.attributedText = exerciseModel.word?.englishExampleAttributedString
        
        self.audioList.append(self.exerciseModel.word?.voice ?? "")
        self.audioList.append(self.exerciseModel.word?.examplePronunciation ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.playAudio()
        }
        
    }

    
    /// 播放语音
    override func playAudio() {
        if let url = audioList.first, url.isNotEmpty {
            audioList.removeFirst()
            self.audioPlayerView?.urlStr = url
            self.audioPlayerView?.play()
        }
    }
    

    func playAudioFinished() {
        self.playAudio()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.audioList.append(self.exerciseModel.word?.voice ?? "")
        self.playAudio()
    }
}
