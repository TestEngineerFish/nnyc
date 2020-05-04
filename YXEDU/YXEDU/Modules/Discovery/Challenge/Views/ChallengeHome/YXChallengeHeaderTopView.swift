//
//  YXChallengeHeaderTopView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeHeaderTopView: UIView {

    var squirrelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeSquirrel")
        return imageView
    }()
    var gameTitleLabel: UILabel = {
        let label = UILabel()
        label.text      = "本活动距离结束还有："
        label.textColor = UIColor.hex(0xE59000)
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        return label
    }()
    var leftGoldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()
    var centerGoldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()
    var rightGoldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()

    var propertyView  = YXChallengePropertyView()

    var countDownView = YXCountDownView()

    var startButton   = YXChallengeStartButton()

    var gameRuleButton: UIButton = {
        let button = UIButton()
        button.setTitle("查看游戏规则", for: .normal)
        button.setTitleColor(UIColor.hex(0xD18714), for: .normal)
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setSubviews()
        self.bindProperty()
//        self.startLeftGoldAnimation()
//        self.startCenterGoldAnimation()
//        self.startRightGoldAnimation()
    }

    deinit {
//        self.stopGoldAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ challengeModel: YXChallengeModel) {
        propertyView.bindData(challengeModel.userModel?.myCoins ?? 0)
        countDownView.bindData(challengeModel.gameInfo?.timeLeft ?? 0)
        startButton.bindData(challengeModel)
    }

    private func bindProperty() {
        self.gameRuleButton.addTarget(self, action: #selector(showRuleView), for: .touchUpInside)
    }

    private func setSubviews() {
        self.addSubview(squirrelImageView)
        self.addSubview(gameTitleLabel)
        self.addSubview(propertyView)
        self.addSubview(countDownView)
        self.addSubview(startButton)
        self.addSubview(gameRuleButton)
        self.addSubview(leftGoldImageView)
        self.addSubview(centerGoldImageView)
        self.addSubview(rightGoldImageView)

        propertyView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.size.equalTo(CGSize(width: AdaptIconSize(44), height: AdaptIconSize(23)))
        }
        squirrelImageView.snp.makeConstraints { (make) in
            if isPad() {
                make.centerX.equalToSuperview().offset(AdaptSize(-40))
            } else {
                make.left.equalToSuperview().offset(AdaptSize(4))
            }
            make.top.equalTo(propertyView.snp.bottom).offset(AdaptSize(11))
            make.size.equalTo(CGSize(width: AdaptIconSize(323), height: AdaptIconSize(115)))
        }
        gameTitleLabel.snp.makeConstraints { (make) in
            if isPad() {
                make.centerX.equalToSuperview().offset(AdaptSize(20))
                make.centerY.equalTo(squirrelImageView)
            } else {
                make.left.equalToSuperview().offset(AdaptSize(150))
                make.top.equalToSuperview().offset(AdaptSize(108))
            }
            make.size.equalTo(CGSize(width: AdaptSize(121), height: AdaptSize(17)))
        }
        countDownView.snp.makeConstraints { (make) in
            make.left.equalTo(gameTitleLabel)
            make.top.equalTo(gameTitleLabel.snp.bottom).offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(170), height: AdaptSize(18)))
        }
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(squirrelImageView.snp.bottom)
            make.size.equalTo(CGSize(width: AdaptIconSize(230), height: AdaptIconSize(57)))
        }
        gameRuleButton.titleLabel?.sizeToFit()
        let gameRuleBtnSize = gameRuleButton.titleLabel?.size ?? CGSize(width: AdaptSize(73), height: AdaptSize(17))
        gameRuleButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(AdaptSize(8))
            make.size.equalTo(gameRuleBtnSize)
        }
        leftGoldImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(-25))
            make.top.equalToSuperview().offset(AdaptSize(26))
            make.size.equalTo(CGSize(width: AdaptIconSize(55), height: AdaptIconSize(55)))
        }
        centerGoldImageView.snp.makeConstraints { (make) in
            make.right.equalTo(startButton.snp.left).offset(AdaptSize(-10))
            make.top.equalTo(startButton.snp.top).offset(AdaptSize(11))
            make.size.equalTo(CGSize(width: AdaptIconSize(22), height: AdaptIconSize(22)))
        }
        rightGoldImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(25))
            make.top.equalToSuperview().offset(AdaptSize(127))
            make.size.equalTo(CGSize(width: AdaptIconSize(55), height: AdaptIconSize(55)))
        }
    }

    // MARK: ==== Event ====
    @objc private func showRuleView() {
        guard let url = YXUserModel.default.gameExplainUrl else {
            return
        }
        YXAlertWebView.share.show(url)
    }

    // MARK: ==== Animation ====
//    private func startLeftGoldAnimation() {
//        let animation = CABasicAnimation(keyPath: "position.y")
//        animation.duration = 1
//        animation.toValue  = AdaptSize(360)
//        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        animation.autoreverses = false
//        animation.repeatCount = MAXFLOAT
//        self.leftGoldImageView.layer.add(animation, forKey: nil)
//    }
//
//    private func startCenterGoldAnimation() {
//        let animation = CABasicAnimation(keyPath: "position.y")
//        animation.duration = 1.5
//        animation.toValue  = AdaptSize(330)
//        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        animation.autoreverses = false
//        animation.repeatCount = MAXFLOAT
//        self.centerGoldImageView.layer.add(animation, forKey: nil)
//    }
//
//    private func startRightGoldAnimation() {
//        let animation = CABasicAnimation(keyPath: "position.y")
//        animation.duration = 1.2
//        animation.toValue  = AdaptSize(360)
//        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        animation.autoreverses = false
//        animation.repeatCount = MAXFLOAT
//        self.rightGoldImageView.layer.add(animation, forKey: nil)
//    }
//
//    private func stopGoldAnimation() {
//        self.leftGoldImageView.layer.removeAllAnimations()
//        self.centerGoldImageView.layer.removeAllAnimations()
//        self.rightGoldImageView.layer.removeAllAnimations()
//    }
}
