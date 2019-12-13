//
//  YXChallengeStartButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXChallengeStatusType {
    case normal
    case lock
    case again

    func getPriceString(_ model: YXChallengeModel) -> NSAttributedString {
        var price = ""
        switch self {
        case .lock:
            price = "\(model.lockPrice)"
        case .again:
            price = "\(model.unitPrice)/次"
        default:
            price = ""
        }
        let mutAttr = NSMutableAttributedString(string: price, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0xFFED3C), NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(20))])
        if self == .again {
            mutAttr.addAttributes([NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(12))], range: NSRange(location: price.count - 2, length: 2))
        }
        return mutAttr
    }
}

class YXChallengeStartButton: YXButton {

    var customTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.textAlignment = .center
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
        label.shadowOffset = CGSize(width: 0, height: 1)
        label.shadowColor  = UIColor.hex(0xE34B0B)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXChallengeModel) {

        self.setSubview(model)
    }

    private func setSubview(_ model: YXChallengeModel) {
        self.addSubview(customTitleLabel)
        switch model.status {
        case .normal:
            self.customTitleLabel.text = "开始学习"
            self.setBackgroundImage(UIImage(named: "challengeButton"), for: .normal)
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        case .lock:
            self.customTitleLabel.text = "解锁"
            self.setBackgroundImage(UIImage(named: "challengeLockButton"), for: .normal)
            let priceView = self.getPriceView(model)
            self.addSubview(priceView)
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(79))
                make.centerY.equalToSuperview().offset(AdaptSize(-3))
                make.size.equalTo(CGSize(width: AdaptSize(41), height: AdaptSize(28)))
            }
            priceView.snp.makeConstraints { (make) in
                make.left.equalTo(customTitleLabel.snp.right)
                make.centerY.equalTo(customTitleLabel)
                make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(28)))
            }
        case .again:
            self.customTitleLabel.text = "再来一次"
            self.setBackgroundImage(UIImage(named: "challengeButton"), for: .normal)
            let priceView = self.getPriceView(model)
            self.addSubview(priceView)
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(40))
                make.centerY.equalToSuperview().offset(AdaptSize(-3))
                make.size.equalTo(CGSize(width: AdaptSize(82), height: AdaptSize(28)))
            }
            priceView.snp.makeConstraints { (make) in
                make.left.equalTo(customTitleLabel.snp.right)
                make.centerY.equalTo(customTitleLabel)
                make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(28)))
            }
        }
    }

    // MARK: ==== Tools ====
    private func getPriceView(_ model: YXChallengeModel) -> UIView {
        let priceView = UIView()
        let leftBracket: UILabel = {
            let label = UILabel()
            label.text          = "（"
            label.textColor     = UIColor.hex(0xFFC372)
            label.textAlignment = .right
            label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
            return label
        }()
        let rightBracket: UILabel = {
            let label = UILabel()
            label.text          = "）"
            label.textColor     = UIColor.hex(0xFFC372)
            label.textAlignment = .left
            label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
            return label
        }()
        let goldImageView: UIImageView = {
            let imageView   = UIImageView()
            imageView.image = UIImage(named: "challengeGoldIcon")
            return imageView
        }()
        let priceLabel: UILabel = {
            let label            = UILabel()
            label.attributedText = model.status.getPriceString(model)
            return label
        }()

        priceView.addSubview(leftBracket)
        priceView.addSubview(goldImageView)
        priceView.addSubview(priceLabel)
        priceView.addSubview(rightBracket)

        leftBracket.snp.makeConstraints { (make) in
            make.left.height.top.equalToSuperview()
            make.width.equalTo(20)
        }
        goldImageView.snp.makeConstraints { (make) in
            make.left.equalTo(leftBracket.snp.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        priceLabel.sizeToFit()
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(goldImageView.snp.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(priceLabel.size)
        }
        rightBracket.snp.makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp.right)
            make.height.top.right.equalToSuperview()
        }
        return priceView
    }


}
