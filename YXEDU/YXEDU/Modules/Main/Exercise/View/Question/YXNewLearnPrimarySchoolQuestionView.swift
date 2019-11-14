//
//  YXNewLearnPrimarySchoolQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


enum NewLearnSubviewType: Int {
    case imageAndAudio
    case wordAndAudio
    case wordAndImageAndAudio
}

class YXNewLearnPrimarySchoolQuestionView: YXBaseQuestionView {

    var wordLabel: UILabel
    var chineseLabel: UILabel
    var viewType: NewLearnSubviewType

    init(exerciseModel: YXWordExerciseModel, type: NewLearnSubviewType) {
        self.viewType = type
        wordLabel     = UILabel()
        chineseLabel  = UILabel()
        super.init(exerciseModel: exerciseModel)
        self.initImageView()
        self.initAudioPlayerView()
        if let urlStr = exerciseModel.question?.imageUrl {
            imageView?.showImage(with: urlStr)
        }
        audioPlayerView?.urlStr = exerciseModel.question?.voice
        self.layer.removeShadow()
        self.clipsToBounds = true
        self.createSubviews(type)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews(_ type: NewLearnSubviewType) {
        super.createSubviews()
        addSubview(wordLabel)
        addSubview(chineseLabel)
        addSubview(imageView!)

        wordLabel.font             = UIFont.pfSCSemiboldFont(withSize: 26)
        wordLabel.text             = self.exerciseModel.word?.word ?? ""
        wordLabel.textColor        = UIColor.black1
        wordLabel.textAlignment    = .center
        chineseLabel.text          = self.exerciseModel.question?.soundmark ?? ""
        chineseLabel.font          = UIFont.pfSCRegularFont(withSize: 14)
        chineseLabel.textColor     = UIColor.black1
        chineseLabel.textAlignment = .center

        switch type {
        case .imageAndAudio:
            wordLabel.isHidden    = true
            chineseLabel.isHidden = true
            imageView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(AdaptSize(150))
                make.height.equalTo(AdaptSize(108))
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView!.snp.bottom).offset(10)
                make.width.height.equalTo(AdaptSize(40))
            }

        case .wordAndAudio:
            imageView?.isHidden = true
            wordLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(40)
            }
            chineseLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(wordLabel.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(20)
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(chineseLabel.snp.bottom).offset(10)
                make.width.height.equalTo(40)
            }

        case .wordAndImageAndAudio:
            wordLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(40)
            }
            chineseLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(wordLabel.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(20)
            }
            imageView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(chineseLabel.snp.bottom).offset(30)
                make.width.equalTo(150)
                make.height.equalTo(108)
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView!.snp.bottom).offset(10)
                make.width.height.equalTo(40)
            }
        }
    }

    override func playAudio() {
        self.audioPlayerView?.play()
    }
    
}
