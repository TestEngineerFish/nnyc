//
//  YXWordAndImageQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 图片+单词+音标题目
class YXWordAndImageQuestionView: YXBaseQuestionView {

    override func createSubviews() {
        super.createSubviews()
        
        self.initImageView()
        self.initTitleLabel()
        self.initAudioPlayerView()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth = self.exerciseModel.question?.word?.textWidth(font: titleLabel!.font, height: 28) ?? 0
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
            make.height.equalTo(28)
        })
        
        audioPlayerView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel!)
            make.left.equalTo(titleLabel!.snp.right).offset(3)
            make.width.height.equalTo(22)
        })
        
        imageView?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(94)
        })
        
    }
    
    override func bindData() {
        let word = (exerciseModel.question?.word ?? "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        self.titleLabel?.text    = word
        
        if let url = self.exerciseModel.word?.imageUrl {
            self.imageView?.showImage(with: url, placeholder: UIImage.imageWithColor(UIColor.orange7))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
}

