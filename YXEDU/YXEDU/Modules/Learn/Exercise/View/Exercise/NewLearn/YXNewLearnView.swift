//
//  YXNewLearnView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import Lottie

/// 跟读页面
class YXNewLearnView: UIView, YXNewLearnProtocol {
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_black"), for: .normal)
        if isPad() {
            button.imageView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.semiboldFont(ofSize: AdaptFontSize(26))
        label.textColor     = UIColor.black1
        label.textAlignment = .center
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textColor     = UIColor.black1
        label.textAlignment = .center
        return label
    }()
    
    var guideView = YXNewLearnGuideView()
    
    var answerView: YXNewLearnAnswerView!
    var wordModel: YXWordModel!
    
    init(wordModel: YXWordModel) {
        self.wordModel = wordModel
        answerView = YXNewLearnAnswerView(wordModel: wordModel, exerciseModel: nil)
        super.init(frame: CGRect.zero)
        self.layer.opacity = 0.0
        self.createSubviews()
        self.bindProperty()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.hideGuideView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(answerView)
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(15))
            make.top.equalToSuperview().offset(AdaptIconSize(35))
            make.size.equalTo(CGSize(width: AdaptIconSize(32), height: AdaptIconSize(32)))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(37))
            make.top.equalTo(closeButton.snp.bottom).offset(AdaptSize(140))
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(20))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(2))
        }
        answerView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-148))
            make.height.equalTo(AdaptIconSize(111))
            make.width.equalToSuperview().offset(AdaptSize(isPad() ? -150 : 0))
        })
    }
    
    private func bindProperty() {
        self.backgroundColor    = UIColor.white.withAlphaComponent(0.95)
        self.titleLabel.text    = wordModel.word
        self.subtitleLabel.text = (wordModel.partOfSpeech ?? "") + " " + (wordModel.meaning ?? "")
        self.answerView.newLearnDelegate = self
        self.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(closedView(_:)), name: YXNotification.kRecordScore, object: nil)
    }
    
    // MARK: ---- Event ----
    @objc private func closeAction() {
        self.answerView.pauseView()
        UIView.animate(withDuration: 0.25, animations: {
            self.layer.opacity = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @objc private func closedView(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String:Int], let lastScore: Int = userInfo["lastScore"] else {
            return
        }
        if lastScore > YXStarLevelEnum.three.rawValue {
            self.closeAction()
        }
    }
    
    func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) {
            self.layer.opacity = 1.0
        }
    }
    
    private func showGuideView() {
        let roundSize  = CGSize(width: AdaptSize(115), height: AdaptSize(115))
        let audioView  = self.answerView.recordAudioButton
        let audioFrame = audioView.convert(audioView.frame, to: kWindow)
        let guideFrame: CGRect = {
            if isPad() {
                return CGRect(x: audioView.frame.midX - roundSize.width/2 + AdaptSize(75), y: audioFrame.midY - roundSize.height + AdaptSize(18), width: roundSize.width, height: roundSize.height)
            } else {
                return CGRect(x: screenWidth - AdaptSize(108) - roundSize.width/2, y: audioFrame.midY - AdaptSize(roundSize.height/2), width: roundSize.width, height: roundSize.height)
            }
        }()
        self.guideView.show(guideFrame)
        YYCache.set(true, forKey: YXLocalKey.alreadShowNewLearnGuideView.rawValue)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideGuideView))
        self.guideView.addGestureRecognizer(tap)
    }
    
    @objc private func hideGuideView() {
        self.guideView.removeFromSuperview()
        self.answerView.status.forward()
     }
    
    // MARK: ---- YXNewLearnProtocol ----
    /// 单词和单词播放结束
    func playWordAndWordFinished() {
        self.answerView.status = .showGuideView
//        if !(YYCache.object(forKey: YXLocalKey.alreadShowNewLearnGuideView.rawValue) as? Bool ?? false)  {
            self.showGuideView()
//        } else {
//            self.answerView.status.forward()
//        }
    }
    
    /// 单词和例句播放结束
    func playWordAndExampleFinished() {}
    /// 显示单词详情
    func showNewLearnWordDetail() {}
    /// 禁用底部所有按钮
    func disableAllButton() {}
    /// 启用底部所有按钮
    func enableAllButton() {}
    
}
