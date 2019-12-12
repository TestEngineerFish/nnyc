//
//  YXChallengePropertyView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengePropertyView: UIView {

    var goldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()

    var numberLabel: UILabel = {
        let label = UILabel()
        label.text      = "0"
        label.font      = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textColor = UIColor.white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.hex(0xE69829).withAlphaComponent(0.62)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipRectCorner(directionList: [.topLeft, .bottomLeft], cornerRadius: AdaptSize(11.5))
        if self.superview != nil {
            self.numberLabel.sizeToFit()
            let w = AdaptSize(32) + self.numberLabel.width
            self.snp.updateConstraints { (make) in
                make.width.equalTo(w)
            }
        }
    }

    func bindData(_ number: Int) {
        self.numberLabel.text = "\(number)"
        self.setNeedsLayout()
    }

    private func setSubviews(){
        self.addSubview(goldImageView)
        self.addSubview(numberLabel)

        goldImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(3))
            make.size.equalTo(CGSize(width: AdaptSize(17), height: AdaptSize(17)))
        }

        numberLabel.sizeToFit()
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goldImageView.snp.right).offset(AdaptSize(6))
            make.centerY.height.equalTo(goldImageView)
            make.width.equalTo(numberLabel.width)
        }
    }
}
