//
//  YXExerciseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 问题面板基类

class YXBaseQuestionView: YXView, YXAnswerEventProtocol {

    let topPadding    = CGFloat(54)
    let bottomPadding = CGFloat(54)
    
    var exerciseModel: YXExerciseModel
    
    /// 主标题
    var titleLabel: UILabel?
    
    /// 子标题
    var subTitleLabel: UILabel?
    
    /// 扩展或者额外的标题（当连个标题都不够用的时候）
    var descTitleLabel: UILabel?
    
    
    var imageView: YXKVOImageView?
    
    /// 播放器
    var audioPlayerView: YXAudioPlayerView?
    
    init(exerciseModel: YXExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.layer.setDefaultShadow()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func initTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel?.font          = UIFont.pfSCSemiboldFont(withSize: AdaptFontSize(26))
        self.titleLabel?.textColor     = UIColor.black1
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.text          = ""
        self.titleLabel?.numberOfLines = 0
        self.addSubview(titleLabel!)
    }
    
    func initSubTitleLabel() {
        self.subTitleLabel                = UILabel()
        self.subTitleLabel?.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(14))
        self.subTitleLabel?.textColor     = UIColor.black3
        self.subTitleLabel?.textAlignment = .center
        self.subTitleLabel?.numberOfLines = 0
        self.addSubview(subTitleLabel!)
    }
    
    func initDescTitleLabel() {
        self.descTitleLabel = UILabel()
        self.descTitleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(14))
        self.descTitleLabel?.textColor = UIColor.black3
        self.descTitleLabel?.textAlignment = .center
        self.descTitleLabel?.text = ""
        self.addSubview(descTitleLabel!)
    }

    func initImageView(set: Bool = true) {
        self.imageView = YXKVOImageView()
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.cornerRadius = AdaptSize(3.78)
        self.imageView?.backgroundColor = UIColor.orange1
        self.addSubview(imageView!)
        if set, let urlStr = self.exerciseModel.word?.imageUrl {
            self.imageView?.showImage(with: urlStr)
        }
    }

    func initAudioPlayerView() {
        self.audioPlayerView = YXAudioPlayerView()
        self.audioPlayerView?.urlStr = self.exerciseModel.word?.voice
        self.addSubview(audioPlayerView!)
    }


    // MARK:YXAnswerEventProtocol
    func selectedAnswerButton(_ button: YXLetterButton) -> Bool { return false }
    /// 取消按钮,移除单词/字母
    func unselectAnswerButton(_ button: YXLetterButton) {}
    func playAudio() {}
    func checkResult() -> (Bool, [Int])? { return nil }

    // MARK: Tools
    func getTitleWidth() -> CGFloat {
        guard let label = self.titleLabel, let text = label.text else {
            return 0
        }
        return text.textWidth(font: label.font, height: label.height)
    }
}
