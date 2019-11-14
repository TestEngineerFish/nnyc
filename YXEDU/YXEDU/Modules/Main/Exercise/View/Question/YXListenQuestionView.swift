//
//  YXListenQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音题目
class YXListenQuestionView: YXBaseQuestionView {
    
    private var audioBackgroundView: UIView = UIView()
    
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(audioBackgroundView)
        self.initAudioPlayerView()
    }
    
    override func bindProperty() {
        self.audioBackgroundView.backgroundColor = UIColor.orange3
        self.audioBackgroundView.layer.masksToBounds = true
        self.audioBackgroundView.layer.cornerRadius = 26
        self.audioBackgroundView.layer.borderWidth = 3
        self.audioBackgroundView.layer.borderColor = UIColor.orange2.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        audioBackgroundView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(52)
        })

        audioPlayerView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        })
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
}
