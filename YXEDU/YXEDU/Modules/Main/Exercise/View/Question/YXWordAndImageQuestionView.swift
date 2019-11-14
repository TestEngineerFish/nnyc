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
        self.initSubTitleLabel()
        self.initAudioPlayerView()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.snp.makeConstraints({ (make) in
            make.top.equalTo(38)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(94)
        })
        
        let titleWidth = self.exerciseModel.question?.word?.textWidth(font: titleLabel!.font, height: 28) ?? 0
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(imageView!.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
            make.height.equalTo(28)
        })
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        })
        
        audioPlayerView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel!)
            make.left.equalTo(titleLabel!.snp.right).offset(3)
            make.width.height.equalTo(22)
        })
        
    }
    
    override func bindData() {
        self.titleLabel?.text = exerciseModel.question?.word
        self.subTitleLabel?.text = exerciseModel.question?.soundmark
        
        if let url = self.exerciseModel.question?.imageUrl {
            self.imageView?.showImage(with: url, placeholder: UIImage.imageWithColor(UIColor.orange7))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
}

