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
        label.text          = "点这里跟读单词，测测自己的发音吧～"
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
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
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(squirrelImageView)
        self.addSubview(descriptionLabel)
        self.addSubview(arrowImageView)
        squirrelImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(112))
            make.top.equalToSuperview().offset(AdaptSize(316))
            make.size.equalTo(CGSize(width: AdaptSize(153), height: AdaptSize(105)))
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(80))
            make.top.equalTo(squirrelImageView.snp.bottom).offset(AdaptSize(4))
            make.size.equalTo(descriptionLabel.size)
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(146))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: 63))
        }
    }

    func show(_ hollowFrame: CGRect) {
        kWindow.addSubview(self)
        self.size = kWindow.size
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let maskLayer  = CAShapeLayer()
        let bezierPath = UIBezierPath(rect: self.bounds)
        let rountBezier = UIBezierPath(roundedRect: hollowFrame, cornerRadius: hollowFrame.height/2).reversing()
        bezierPath.append(rountBezier)
        maskLayer.path = bezierPath.cgPath
        self.layer.mask = maskLayer
    }

    func hide() {
        self.removeFromSuperview()
    }
}
