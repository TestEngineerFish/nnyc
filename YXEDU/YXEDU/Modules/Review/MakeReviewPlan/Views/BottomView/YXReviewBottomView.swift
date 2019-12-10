//
//  YXReviewBottomView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewBottomView: UIView {

    var makeButton: YXButton = {
        let button = YXButton()
        button.setTitle("创建复习计划", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()

    var remindLabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textColor = UIColor.black3
        label.text      = "单个复习计划控制在150个单词内，效果最佳哦"
        label.layer.masksToBounds = true
        label.textAlignment       = .center
        label.isHidden            = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.setDefaultShadow()
        self.setSubviews()
        self.hideRemind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        self.addSubview(makeButton)
        self.addSubview(remindLabel)

        let buttonSize = CGSize(width: AdaptSize(273), height: AdaptSize(42))
        self.makeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.centerX.equalToSuperview()
            make.size.equalTo(buttonSize)
        }

        self.makeButton.backgroundColor = UIColor.gradientColor(with: buttonSize, colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
        self.makeButton.layer.cornerRadius = buttonSize.height / 2
        self.remindLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.makeButton.snp.bottom).offset(AdaptSize(8))
            make.left.right.equalToSuperview()
            make.height.equalTo(CGFloat.zero)
        }
    }

    // MARK: ==== Event ====
    func showRemind() {
        if self.superview != nil {
            self.remindLabel.isHidden = false
            self.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(81) + kSafeBottomMargin)
            }
            self.remindLabel.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(17))
            }
        }
    }

    func hideRemind() {
        if self.superview != nil {
            self.remindLabel.isHidden = true
            self.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(60))
            }
            self.remindLabel.snp.updateConstraints { (make) in
                make.height.equalTo(CGFloat.zero)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
        self.showRemind()
        self.setNeedsLayout()
    }
}
