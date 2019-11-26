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

    var viewType: NewLearnSubviewType

    init(exerciseModel: YXWordExerciseModel, type: NewLearnSubviewType) {
        self.viewType = type
        super.init(exerciseModel: exerciseModel)
        self.initTitleLabel()
        self.initSubTitleLabel()
        self.initImageView()
        self.initAudioPlayerView()
        if let wordModel = self.exerciseModel.word {
            self.titleLabel?.text = wordModel.word
            self.subTitleLabel?.text = wordModel.meaning
        }
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

        switch type {
        case .imageAndAudio:
            titleLabel?.isHidden    = true
            subTitleLabel?.isHidden = true
            imageView?.isHidden     = false
            imageView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(AdaptSize(150))
                make.height.equalTo(AdaptSize(108))
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView!.snp.bottom).offset(AdaptSize(10))
                make.width.height.equalTo(AdaptSize(40))
            }

        case .wordAndAudio:
            titleLabel?.isHidden    = false
            subTitleLabel?.isHidden = false
            imageView?.isHidden     = true
            titleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(40))
            }
            subTitleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel!.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(20))
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(subTitleLabel!.snp.bottom).offset(AdaptSize(10))
                make.width.height.equalTo(AdaptSize(40))
            }

        case .wordAndImageAndAudio:
            titleLabel?.isHidden    = false
            subTitleLabel?.isHidden = false
            imageView?.isHidden     = false
            titleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(40))
            }
            subTitleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel!.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(AdaptSize(20))
            }
            imageView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(subTitleLabel!.snp.bottom).offset(AdaptSize(30))
                make.width.equalTo(AdaptSize(150))
                make.height.equalTo(AdaptSize(108))
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView!.snp.bottom).offset(AdaptSize(10))
                make.width.height.equalTo(AdaptSize(40))
            }
        }
    }

    override func playAudio() {
        self.audioPlayerView?.play()
    }
    
}
