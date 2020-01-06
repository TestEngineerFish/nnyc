//
//  YXExerciseLoadingView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXExerciseLoadingView: UIView, CAAnimationDelegate {
    var progressLayer = CAGradientLayer()
    var dotLayer      = CAGradientLayer()
    var finished      = false
    var completeBlock: (()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.backgroundColor = UIColor.white


        let headerView = self.createHeaderView()
        let fooderView = self.createFooterView()
        self.addSubview(headerView)
        self.addSubview(fooderView)
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        fooderView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }

    private func createHeaderView() -> UIView {
        let headerView     = UIView()
        let squirrelView   = AnimationView(name: "learnLoading")
        let descLabel      = UILabel()
        let progressBgView = UIView()

        descLabel.textAlignment = .center
        descLabel.textColor     = UIColor.black6
        descLabel.font          = UIFont.pfSCRegularFont(withSize: 12)
        descLabel.text          = "努力加载中…"

        progressBgView.layer.cornerRadius  = AdaptSize(15)/2
        progressBgView.layer.masksToBounds = true
        progressBgView.backgroundColor     = UIColor.hex(0xF2F2F2)

        progressLayer.cornerRadius    = AdaptSize(15)/2
        progressLayer.masksToBounds   = true
        progressLayer.backgroundColor = UIColor.orange1.cgColor

        dotLayer.borderWidth     = 3.0
        dotLayer.borderColor     = UIColor.orange1.cgColor
        dotLayer.cornerRadius    = AdaptSize(15)/2
        dotLayer.masksToBounds   = true
        dotLayer.backgroundColor = UIColor.white.cgColor

        headerView.addSubview(squirrelView)
        headerView.addSubview(descLabel)
        headerView.addSubview(progressBgView)
        progressBgView.layer.addSublayer(progressLayer)
        progressBgView.layer.addSublayer(dotLayer)

        squirrelView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(102))
            make.size.equalTo(CGSize(width: AdaptSize(330), height: AdaptSize(228)))
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(squirrelView.snp.bottom).offset(AdaptSize(21))
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(25))
        }
        progressBgView.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(AdaptSize(4))
            make.width.equalTo(AdaptSize(189))
            make.height.equalTo(AdaptSize(15))
            make.centerX.equalToSuperview()
        }
        self.progressLayer.frame = CGRect(x: 0, y: 0, width: AdaptSize(189), height: AdaptSize(15))
        self.dotLayer.frame = CGRect(x: 0, y: 0, width: AdaptSize(15), height: AdaptSize(15))
        squirrelView.play()
        return headerView
    }

    private func createFooterView() -> UIView {
        let fooderView    = UIView()
        let bgImageView   = UIImageView(image: UIImage(named: "loading_bg"))
        let tipsImageView = UIImageView(image: UIImage(named: "icon_tips"))
        let titleLabel    = UILabel()

        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.textColor     = UIColor.orange1
        titleLabel.font          = UIFont.pfSCMediumFont(withSize: 15)
        titleLabel.text          = self.getRandomTips()

        fooderView.addSubview(bgImageView)
        fooderView.addSubview(tipsImageView)
        fooderView.addSubview(titleLabel)

        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(50))
            make.bottom.equalToSuperview().offset(AdaptSize(-63)-kSafeBottomMargin)
        }
        tipsImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel).offset(AdaptSize(32))
            make.bottom.equalTo(titleLabel.snp.top).offset(AdaptSize(-9))
            make.size.equalTo(CGSize(width: AdaptSize(42), height: AdaptSize(24)))
        }

        return fooderView
    }
    
    // TODO: ==== Tools ====
    private func getRandomTips() -> String {
        let tipsArray = ["阅读碰到不认识的单词\n主页点击右上角放大镜图片",
                         "已经学会的单词，可以点击已掌握\n增加学习效率",
                         "遇到实用的词，可以收藏起来\n经常看看，可以温故而知新",
                         "错词本就在首页，经常温习\n错误就会越来越少",
                         "好用的话记得给我们的App来个五星好评哦",
                         "分享给你的好朋友\n一起进步，才是牢固的羁绊"]
        let encourageArray = ["学习不在于学习的量有多少\n而在于坚持与质量",
                              "天天要读书是很累\n不过累着累着就突破了",
                              "学霸就是要在别人不知道的时候努力",
                              "越倒霉越努力，努力着努力着就顺了",
                              "要说天才的优势是什么\n那就是他天生会学习"]
        let totalArray = tipsArray + encourageArray
        return totalArray.randomElement() ?? ""
    }

    // MARK: Animation
    func showAnimation() {
        let dotAnimation = CABasicAnimation(keyPath: "position.x")
        dotAnimation.toValue        = AdaptSize(181)
        dotAnimation.repeatCount    = 1
        dotAnimation.duration       = 3
        dotAnimation.autoreverses   = false
        dotAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        dotAnimation.fillMode       = .forwards
        dotAnimation.isRemovedOnCompletion = false
        dotLayer.add(dotAnimation, forKey: "dotAnimation")

        let proMaskLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: AdaptSize(15)/2))
        path.addLine(to: CGPoint(x: AdaptSize(189), y: AdaptSize(15)/2))
        proMaskLayer.path        = path.cgPath
        proMaskLayer.lineWidth   = AdaptSize(15)
        proMaskLayer.lineJoin    = .round
        proMaskLayer.strokeColor = UIColor.blue.cgColor
        proMaskLayer.fillColor   = nil

        self.progressLayer.mask = proMaskLayer
        let proAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let fromRate     = AdaptSize(7.5/189)
        proAnimation.fromValue      = fromRate
        proAnimation.toValue        = 1.0 - fromRate
        proAnimation.repeatCount    = 1
        proAnimation.duration       = 3
        proAnimation.autoreverses   = false
        proAnimation.fillMode       = .forwards
        proAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        proAnimation.delegate       = self
        proMaskLayer.add(proAnimation, forKey: "proAnimation")

    }

    func stopAnimation(_ completeBlock: (()->Void)?) {
        self.finished = true
        self.completeBlock = completeBlock
    }

    // MARK: CAAnimationDelegate

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.finished {
            self.removeFromSuperview()
            self.completeBlock?()
        } else {
            self.showAnimation()
        }
    }
}
