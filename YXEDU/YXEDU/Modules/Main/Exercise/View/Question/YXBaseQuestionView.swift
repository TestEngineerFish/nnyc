//
//  YXExerciseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 问题面板基类

class YXBaseQuestionView: UIView, YXAnswerEventProtocol {

    let topPadding    = CGFloat(54)
    let bottomPadding = CGFloat(54)
    
    var exerciseModel: YXWordExerciseModel
    
    /// 主标题
    var titleLabel: UILabel?
    
    /// 子标题
    var subTitleLabel: UILabel?
    
    /// 扩展或者额外的标题（当连个标题都不够用的时候）
    var descTitleLabel: UILabel?
    
    
    var imageView: YXKVOImageView?
    
    /// 播放器
    var playerView: YXExerciseAudioPlayerView?

    /// 处理协议
    var delegate: YXQuestionEventProtocol?
    
    init(exerciseModel: YXWordExerciseModel) {
        self.exerciseModel = exerciseModel
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.layer.setDefaultShadow()
        self.createSubviews()
        self.bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {}
    
    func initTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: 20)
        self.titleLabel?.textColor = UIColor.black1
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.text = "coffee"
        
        self.addSubview(titleLabel!)
    }
    
    
    func initSubTitleLabel() {
        self.subTitleLabel                = UILabel()
        self.subTitleLabel?.font          = UIFont.pfSCRegularFont(withSize: 14)
        self.subTitleLabel?.textColor     = UIColor.hex(0x888888)
        self.subTitleLabel?.textAlignment = .center
        self.addSubview(subTitleLabel!)
    }
    
    func initDescTitleLabel() {
        self.descTitleLabel = UILabel()
        self.descTitleLabel?.font = UIFont.pfSCRegularFont(withSize: 14)
        self.descTitleLabel?.textColor = UIColor.black2
        self.descTitleLabel?.textAlignment = .center
        self.descTitleLabel?.text = "n.（名词）小船，艇"
        self.addSubview(descTitleLabel!)
    }

    func initImageView() {
        self.imageView = YXKVOImageView()
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.cornerRadius = 3.78
        self.imageView?.backgroundColor = UIColor.orange1
        
        self.addSubview(imageView!)
    }
    
    
    func initPlayerView() {
        self.playerView = YXExerciseAudioPlayerView()
        self.addSubview(playerView!)
    }
    
    func bindData()  {}

    // MARK:YXAnswerEventProtocol
    /// 选中按钮,添加单词/字母
    /// - returns: 是否添加成功
    func selectedAnswerButton(_ button: YXLetterButton) -> Bool {
        return false
    }
    /// 取消按钮,移除单词/字母
    func unselectAnswerButton(_ button: YXLetterButton) {}
    /// 检验答题结果
    func checkAnserResult() {}
    func switchQuestion() {}
    func playAudio() {}
}
