//
//  YXNewLearnPrimarySchoolWordGroupQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/14.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnPrimarySchoolWordGroupQuestionView: YXBaseQuestionView {
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
        let titleW = self.getTitleWidth()
        switch type {
        case .imageAndAudio:
            break
        case .wordAndAudio:
            titleLabel?.isHidden    = false
            subTitleLabel?.isHidden = false
            imageView?.isHidden     = true

            titleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(titleW)
                make.height.equalTo(40)
            }
            subTitleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel!.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(20)
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.left.equalTo(titleLabel!.snp.right)
                make.centerY.equalTo(titleLabel!)
                make.width.height.equalTo(AdaptSize(25))
            }
        case .wordAndImageAndAudio:
            titleLabel?.isHidden    = false
            subTitleLabel?.isHidden = false
            imageView?.isHidden     = false
            titleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(titleW)
                make.height.equalTo(40)
            }
            subTitleLabel?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel!.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(20)
            }
            imageView?.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(subTitleLabel!.snp.bottom).offset(30)
                make.width.equalTo(150)
                make.height.equalTo(108)
            }
            audioPlayerView?.snp.makeConstraints { (make) in
                make.left.equalTo(titleLabel!.snp.right)
                make.centerY.equalTo(titleLabel!)
                make.width.height.equalTo(AdaptSize(25))
            }
        }
    }

    override func playAudio() {
        self.audioPlayerView?.play()
    }
}
