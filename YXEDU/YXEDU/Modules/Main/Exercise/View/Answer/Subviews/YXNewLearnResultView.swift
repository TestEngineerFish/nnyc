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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(6)
        return view
    }()
    
    var animationView: AnimationView = {
        let animation = AnimationView(name: "resultLoading")
        return animation
    }()

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var firstStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var secondStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var thirdStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
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
        contentView.addSubview(firstStarImageView)
        contentView.addSubview(secondStarImageView)
        contentView.addSubview(thirdStarImageView)
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
        firstStarImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(secondStarImageView).offset(AdaptSize(2))
            make.right.equalTo(secondStarImageView.snp.left).offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
        }
        secondStarImageView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(iconImageView).offset(AdaptSize(8))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        thirdStarImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(secondStarImageView.snp.right).offset(AdaptSize(-6))
            make.centerY.equalTo(secondStarImageView).offset(AdaptSize(2))
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
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
        titleLabel.text      = "正在打分…"
        titleLabel.textColor = UIColor.black6
        titleLabel.sizeToFit()
        self.createBaseSubviews()
        self.createReportSubviews()
        self.animationView.play()
        self.layoutSubviews()
    }
    
    /// 显示结果动画
    func showResultView(_ star: Int) {
        self.animationView.removeFromSuperview()
        self.createBaseSubviews()
        self.createResultSubviews()
        self.iconImageView.image    = UIImage(named: "learnResult\(star)")
        firstStarImageView.image    = UIImage(named: "star_h_disable")
        secondStarImageView.image   = UIImage(named: "star_h_disable")
        thirdStarImageView.image    = UIImage(named: "star_h_disable")
        bonusLabel.text             = "+\(star)"
        titleLabel.text             = "Try again"
        bonusLabel.isHidden         = true
        goldImageView.isHidden      = true
        if star > 0 {
            firstStarImageView.image = UIImage(named: "star_h_enable")
        }
        if star > 1 {
            goldImageView.isHidden = false
            bonusLabel.isHidden    = false
            titleLabel.text        = "太棒啦"
            secondStarImageView.image = UIImage(named: "star_h_enable")
        }
        if star > 2 {
            thirdStarImageView.image = UIImage(named: "star_h_enable")
        }
        self.layoutSubviews()
    }
    
    /// 显示网络错误视图
    func showNetworkErrorView() {
        self.animationView.removeFromSuperview()
        self.createBaseSubviews()
        self.createNetworkErrorSubviews()
        iconImageView.image  = UIImage(named: "noNetwork1")
        titleLabel.text      = "网络开小差了,请重试"
        titleLabel.textColor = UIColor.black1
        titleLabel.sizeToFit()
        self.layoutSubviews()
    }

    func hideView() {
        self.removeAllSubviews()
        self.removeFromSuperview()
    }
}
