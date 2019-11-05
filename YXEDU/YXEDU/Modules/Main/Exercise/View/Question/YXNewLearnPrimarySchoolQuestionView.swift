//
//  YXNewLearnPrimarySchoolQuestionView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnPrimarySchoolQuestionView: YXBaseQuestionView {

    let contentView = UIView()
    var firstView: YXNewLearnQuestionSubview?
    var secondView: YXNewLearnQuestionSubview?
    var thirdView: YXNewLearnQuestionSubview?
    var currentView: YXNewLearnQuestionSubview?

    override func createSubviews() {
        super.createSubviews()
        self.clipsToBounds = true
        firstView  = YXNewLearnQuestionSubview(exerciseModel: exerciseModel, type: .imageAndAudio)
        secondView = YXNewLearnQuestionSubview(exerciseModel: exerciseModel, type: .wordAndAudio)
        thirdView  = YXNewLearnQuestionSubview(exerciseModel: exerciseModel, type: .wordAndImageAndAudio)

        self.addSubview(contentView)
        self.contentView.addSubview(firstView!)
        self.contentView.addSubview(secondView!)
        self.contentView.addSubview(thirdView!)

        contentView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(3.0)
        }

        firstView?.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(self)
            make.height.equalTo(158)
        }

        secondView?.snp.makeConstraints { (make) in
            make.left.equalTo(firstView!.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(self)
            make.height.equalTo(110)
        }

        thirdView?.snp.makeConstraints { (make) in
            make.left.equalTo(secondView!.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(self)
            make.height.equalTo(250)
        }

        self.layer.removeShadow()
        self.currentView = firstView
        firstView?.audioView.clickAudioBtn(firstView!.audioView.audioButton)
    }

    override func switchQuestion() {
        super.switchQuestion()
        guard let currentView = self.currentView else {
            return
        }
        var offsetX = CGFloat.zero
        switch currentView {
        case firstView:
            offsetX = -self.width * 1
            if let view = secondView {
                view.audioView.clickAudioBtn(view.audioView.audioButton)
            }
        case secondView:
            offsetX = -self.width * 2
            if let view = thirdView {
                view.audioView.clickAudioBtn(view.audioView.audioButton)
            }
        default:
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.contentView.transform = CGAffineTransform(translationX: offsetX, y: 0)
        }
    }
    
}
