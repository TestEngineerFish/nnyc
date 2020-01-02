//
//  YXMakeReviewGuideView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/2.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXMakeReviewGuideView: UIView {
    var fingerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "makeGuideFinger")
        return imageView
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "手指滑动，快速选中单词"
        label.textColor     = UIColor.white
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var confirmButton: YXButton = {
        let button = YXButton()
        button.setTitle("我知道啦", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        button.cornerRadius     = AdaptSize(21)
        button.borderColor      = UIColor.white
        button.borderWidth      = AdaptSize(1)
        button.backgroundColor  = UIColor.clear
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubview()
        self.bindPropertry()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindPropertry() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.confirmButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }

    private func createSubview() {
        self.addSubview(fingerImageView)
        self.addSubview(descriptionLabel)
        self.addSubview(confirmButton)
        fingerImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(200))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(50), height: AdaptSize(50)))
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(217))
            make.left.equalToSuperview().offset(AdaptSize(105))
            make.size.equalTo(descriptionLabel.size)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-130) - kSafeBottomMargin)
            make.size.equalTo(CGSize(width: AdaptSize(230), height: AdaptSize(42)))
        }
    }

    // MARK: ==== Event ====
    func show() {
        kWindow.addSubview(self)
        self.size = kWindow.size
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let maskLayer   = CAShapeLayer()
        let bezierPath  = UIBezierPath(rect: self.bounds)
        maskLayer.path  = bezierPath.cgPath
        self.layer.mask = maskLayer
        self.startAnimation()
    }

    @objc private func hide() {
        YYCache.set(true, forKey: YXLocalKey.alreadShowMakeReviewGuideView.rawValue)
        self.stopAnimation()
        self.removeFromSuperview()
    }

    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration       = 0.75
        animation.toValue        = AdaptSize(400)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount    = MAXFLOAT
        animation.autoreverses   = false
        self.fingerImageView.layer.add(animation, forKey: nil)
    }
    private func stopAnimation() {
        self.fingerImageView.layer.removeAllAnimations()
    }
}
