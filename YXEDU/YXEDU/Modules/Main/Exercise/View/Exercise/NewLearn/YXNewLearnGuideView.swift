//
//  YXNewLearnGuideView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXNewLearnGuideView: UIView {

    var squirrelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newLearnGuideSquirrel")
        return imageView
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "点这里跟读，测测自己的发音吧~\n跟读通过可以得到松果币奖励哦"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newLearnGuideArrow")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews(_ frame:CGRect) {
        self.addSubview(squirrelImageView)
        self.addSubview(descriptionLabel)
        self.addSubview(arrowImageView)

        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(frame.minX - AdaptSize(20 + 45))
            make.top.equalToSuperview().offset(frame.minY - AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(63)))
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.bottom.equalTo(arrowImageView.snp.top).offset(AdaptSize(-6))
            make.size.equalTo(descriptionLabel.size)
        }
        squirrelImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(AdaptSize(-4))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(153), height: AdaptSize(105)))
        }
    }

    func show(_ hollowFrame: CGRect) {
        kWindow.addSubview(self)
        self.size = kWindow.size
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let maskLayer   = CAShapeLayer()
        let bezierPath  = UIBezierPath(rect: self.bounds)
        let rountBezier = UIBezierPath(roundedRect: hollowFrame, cornerRadius: hollowFrame.height/2).reversing()
        bezierPath.append(rountBezier)
        maskLayer.path  = bezierPath.cgPath
        self.layer.mask = maskLayer
        self.createSubviews(hollowFrame)
    }

    func hide() {
        self.removeFromSuperview()
    }
}
