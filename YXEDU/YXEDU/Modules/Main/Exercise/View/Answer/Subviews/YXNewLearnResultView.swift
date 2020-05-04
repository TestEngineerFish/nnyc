//
//  YXNewLearnResultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXNewLearnResultView: UIView {

    var backgroundView: UIView = {
        let view = UIView()
        view.isHidden        = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.isHidden           = true
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(6)
        return view
    }()
    
    var animationView: AnimationView = {
        let animation = AnimationView(name: "resultLoading")
        animation.isHidden = true
        return animation
    }()

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var starView = YXStarView()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.isHidden      = true
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .center
        return label
    }()

    var goldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeGoldIcon")
        imageView.isHidden = true
        return imageView
    }()

    var bonusLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.orange1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()
    
    deinit {
        self.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.snp.updateConstraints { (make) in
            make.size.equalTo(titleLabel.size)
        }
        self.bonusLabel.sizeToFit()
        self.bonusLabel.snp.updateConstraints { (make) in
            make.size.equalTo(bonusLabel.size)
        }
        if self.goldImageView.isHidden {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(211))
            }
        } else {
            self.contentView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(226))
            }
        }
    }
    
    private func createBaseSubviews() {
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 创建上报页
    private func createReportSubviews() {
        self.addSubview(contentView)
        contentView.addSubview(animationView)
        contentView.addSubview(titleLabel)
        
        contentView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(AdaptSize(220))
            make.width.equalTo(AdaptSize(270))
        }
        animationView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(38))
            make.size.equalTo(CGSize(width: AdaptSize(80), height: AdaptSize(80)))
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).offset(AdaptSize(11))
            make.height.equalTo(AdaptSize(24))
            make.width.equalTo(titleLabel.width)
        }
    }

    /// 创建结果页
    private func createResultSubviews() {
        self.addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(starView)
        contentView.addSubview(goldImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bonusLabel)

        contentView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(AdaptSize(226))
            make.width.equalTo(AdaptSize(275))
        }
        iconImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(38))
            make.size.equalTo(CGSize(width: AdaptSize(233), height: AdaptSize(109)))
        }
        starView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(iconImageView)
            make.height.equalTo(AdaptSize(45))
            make.width.equalTo(AdaptSize(118))
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(AdaptSize(11))
            make.size.equalTo(CGSize.zero)
        }
        goldImageView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(116))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        bonusLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(goldImageView.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(goldImageView)
            make.size.equalTo(CGSize.zero)
        }
    }
    
    /// 创建网络错误页
    private func createNetworkErrorSubviews() {
        self.addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        contentView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(AdaptSize(220))
            make.width.equalTo(AdaptSize(270))
        }
        iconImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(2))
            make.size.equalTo(CGSize(width: AdaptSize(222), height: AdaptSize(177)))
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-30))
            make.height.equalTo(AdaptSize(24))
            make.width.equalTo(titleLabel.width)
        }
    }
    
    // MARK: ---- Animation ----
    
    /// 显示上报视图
    func showReportView() {
        self.createBaseSubviews()
        self.backgroundView.isHidden = false
        self.contentView.isHidden    = false
        self.titleLabel.isHidden     = false
        self.animationView.isHidden  = false
        titleLabel.text              = "正在打分…"
        titleLabel.textColor         = UIColor.black6
        titleLabel.sizeToFit()
        self.createReportSubviews()
        self.animationView.play()
        self.layoutSubviews()
    }
    
    func hideReportView() {
        self.contentView.isHidden   = true
        self.titleLabel.isHidden    = true
        self.animationView.isHidden = true
    }
    
    /// 显示结果动画
    func showResultView(_ score: Int, coin: Int) {
        let starNum: Int = YXStarLevelEnum.getStarNum(score)
        self.createResultSubviews()
        self.starView.showNewLearnResultView(starNum: starNum)
        self.iconImageView.image    = UIImage(named: "learnResult\(starNum)")
        bonusLabel.text             = "+\(coin)"
        titleLabel.textColor        = .black1
        if starNum > 1 {
            titleLabel.text        = "太棒啦"
        } else {
            titleLabel.text        = "Try again"
        }
        if coin > 0 {
            goldImageView.isHidden = false
            bonusLabel.isHidden    = false
        } else {
            goldImageView.isHidden = true
            bonusLabel.isHidden    = true
        }
        self.titleLabel.isHidden  = false
        self.layoutSubviews()
        self.contentView.isHidden = false
        self.showAnimation()
    }
    
    /// 显示网络错误视图
    func showNetworkErrorView() {
        self.createNetworkErrorSubviews()
        iconImageView.image  = UIImage(named: "noNetwork1")
        titleLabel.text      = "网络开小差了,请重试"
        titleLabel.textColor = UIColor.black1
        titleLabel.sizeToFit()
        self.contentView.isHidden = false
        self.titleLabel.isHidden  = false
        self.layoutSubviews()
    }
    
    func hideView() {
        self.hideAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.contentView.removeAllSubviews()
            self.removeAllSubviews()
            self.removeFromSuperview()
        }
    }
    
    // MARK: ---- Animation ----
    private func showAnimation() {
        let scaleAnimater       = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimater.values    = [0.6, 1.0]

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.6, 1.0]

        let animationGroup = CAAnimationGroup()
        animationGroup.animations     = [scaleAnimater, opacityAnimation]
        animationGroup.autoreverses   = false
        animationGroup.repeatCount    = 1
        animationGroup.duration       = 0.5
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.contentView.layer.add(animationGroup, forKey: nil)
    }
    
    private func hideAnimation() {
        let scaleAnimater       = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimater.values    = [1.0, 0.0]

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [1.0, 0.0]

        let animationGroup = CAAnimationGroup()
        animationGroup.animations     = [scaleAnimater, opacityAnimation]
        animationGroup.autoreverses   = false
        animationGroup.repeatCount    = 1
        animationGroup.duration       = 0.5
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.contentView.layer.add(animationGroup, forKey: nil)
    }
}
