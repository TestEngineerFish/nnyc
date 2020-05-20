//
//  YXReviewBottomView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/10.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXReviewBottomViewProtocol: NSObjectProtocol {
    func showRemind()
    func hideRemind()
    func setButtonStatus(_ status: YXButtonStatusEnum)
}

class YXReviewBottomView: UIView, YXReviewBottomViewProtocol {

    var makeButton: YXButton = {
        let button = YXButton(.theme)
        button.setTitle("创建词单", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(17))
        button.setStatus(.disable)
        return button
    }()

    var remindLabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.pfSCMediumFont(withSize: AdaptFontSize(12))
        label.textColor = UIColor.black3
        label.text      = "单个词单控制在150个单词内，效果最佳哦"
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

        self.makeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.centerX.equalToSuperview()
            make.width.equalTo(AdaptIconSize(273))
            make.height.equalTo(AdaptIconSize(42))
        }
        self.remindLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.makeButton.snp.bottom).offset(AdaptSize(8))
            make.left.right.equalToSuperview()
            make.height.equalTo(CGFloat.zero)
        }
    }

    // MARK: ==== YXReviewBottomView ====
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

    func setButtonStatus(_ status: YXButtonStatusEnum) {
        self.makeButton.setStatus(status)
    }
}
