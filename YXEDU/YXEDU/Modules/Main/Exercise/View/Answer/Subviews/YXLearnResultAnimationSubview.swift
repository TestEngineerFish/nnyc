//
//  YXLearnResultAnimationSubview.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXLearnResultAnimationSubview: UIView {

    var imageView  = UIImageView()
    var firstStar  = UIImageView()
    var secondStar = UIImageView()
    var thirdStar  = UIImageView()

    init(_ level: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 85))
        self.firstStar.image      = UIImage(named: "star_enable")
        if level > 1 {
            self.secondStar.image = UIImage(named: "star_enable")
            self.imageView.image  = UIImage(named: "star_enable")
        } else {
            self.secondStar.image = UIImage(named: "star_disable")
            self.imageView.image  = UIImage(named: "lower_result")
        }
        if level > 2 {
            self.thirdStar.image  = UIImage(named: "star_enable")
        } else {
            self.thirdStar.image  = UIImage(named: "star_disable")
        }
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        self.addSubview(imageView)
        self.addSubview(firstStar)
        self.addSubview(secondStar)
        self.addSubview(thirdStar)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(48)
        }
        secondStar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(30)
        }
        firstStar.snp.makeConstraints { (make) in
            make.right.equalTo(secondStar.snp.left).offset(-5)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(16)
        }
        thirdStar.snp.makeConstraints { (make) in
            make.left.equalTo(secondStar.snp.right).offset(5)
            make.top.equalTo(firstStar)
            make.width.height.equalTo(16)
        }
        imageView.isHidden  = true
        firstStar.isHidden  = true
        secondStar.isHidden = true
        thirdStar.isHidden  = true
    }

    func showAnimation() {
        let duration = Double(0.75)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.0, 1.2, 1.0]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.imageView.isHidden = false
            self.imageView.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*1) {
            self.firstStar.isHidden = false
            self.firstStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*2) {
            self.secondStar.isHidden = false
            self.secondStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*3) {
            self.thirdStar.isHidden = false
            self.thirdStar.layer.add(animation, forKey: nil)
        }

    }

    func hideAnimation() {
        let duration  = Double(0.75)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values         = [1.0, 1.2, 0.0]
        animation.duration       = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let imgAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values         = [1.0, 1.0, 0.0]
        animation.duration       = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = Float.zero
        rotateAnimation.toValue   = Float.pi
        rotateAnimation.duration  = duration
        rotateAnimation.autoreverses = false
        rotateAnimation.fillMode = .forwards
        rotateAnimation.repeatCount = 1

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [imgAnimation, rotateAnimation]
        groupAnimation.duration = duration


        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.imageView.isHidden = false
            self.imageView.layer.add(groupAnimation, forKey: nil)
            self.firstStar.isHidden = false
            self.firstStar.layer.add(animation, forKey: nil)
            self.secondStar.isHidden = false
            self.secondStar.layer.add(animation, forKey: nil)
            self.thirdStar.isHidden = false
            self.thirdStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration - 0.1) {
            self.imageView.isHidden  = true
            self.firstStar.isHidden  = true
            self.secondStar.isHidden = true
            self.thirdStar.isHidden  = true
            self.removeFromSuperview()
        }

    }
}
