//
//  YXStarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXStarView: UIView {
    
    var leftStarDisableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()
    var leftStarEnableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "star_h_enable")
        imageView.isHidden = true
        return imageView
    }()
    var centerStarDisableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()
    var centerStarEnableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "star_h_enable")
        imageView.isHidden = true
        return imageView
    }()
    var rightStarDisableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star_h_disable")
        return imageView
    }()
    var rightStarEnableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "star_h_enable")
        imageView.isHidden = true
        return imageView
    }()
    
    var starNumber = 0
    
    /// 上次学习结果
    func showLastNewLearnResultView(score: Int) {
        self.starNumber = {
            if score > YXStarLevelEnum.three.rawValue {
                return 3
            } else if score > YXStarLevelEnum.two.rawValue {
                return 2
            } else if score > YXStarLevelEnum.one.rawValue {
                return 1
            } else if score > YXStarLevelEnum.zero.rawValue {
                return 0
            } else {
                return -1
            }
        }()
        self.setStarStatus()
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(30)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.top.equalTo(centerStarDisableImageView).offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.top.equalTo(leftStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 新学结果页
    func showResultView(starNum: Int) {
        self.starNumber = starNum
        self.resetStatus()
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(30)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.top.equalTo(centerStarDisableImageView).offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.top.equalTo(leftStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.showAnimation()
    }
    
    /// 显示流程学习结果
    func showLearnResultView(starNum: Int) {
        self.starNumber = starNum
        self.resetStatus()
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.showAnimation()
    }
    
    // MARK: ---- Tools ----
    private func setStarStatus() {
        if self.starNumber > 0 {
            leftStarEnableImageView.isHidden   = false
        }
        if self.starNumber > 1 {
            centerStarEnableImageView.isHidden = false
        }
        if self.starNumber > 2 {
            rightStarEnableImageView.isHidden  = false
        }
        if self.starNumber < 0 {
            leftStarDisableImageView.isHidden   = true
            centerStarDisableImageView.isHidden = true
            rightStarDisableImageView.isHidden  = true
        } else {
            leftStarDisableImageView.isHidden   = false
            centerStarDisableImageView.isHidden = false
            rightStarDisableImageView.isHidden  = false
        }
    }
    
    private func resetStatus() {
        self.leftStarEnableImageView.isHidden   = true
        self.centerStarEnableImageView.isHidden = true
        self.rightStarEnableImageView.isHidden  = true
    }
    
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values         = [0, 1.1, 1.0]
        animation.duration       = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        if self.starNumber > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.leftStarEnableImageView.isHidden = false
                self.leftStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar1()
            }
        }
        if self.starNumber > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.centerStarEnableImageView.isHidden = false
                self.centerStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar2()
            }
        }
        if self.starNumber > 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.rightStarEnableImageView.isHidden = false
                self.rightStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar3()
            }
        }
    }
}