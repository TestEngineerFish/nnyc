//
//  YXChallengeStartButton.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXChallengeStatusType: Int {

    case lock  = 0
    case task  = 1
    case free  = 3
    case again = 4

    func getPriceString(_ model: YXChallengeModel) -> NSAttributedString {
        var price = ""
        switch self {
        case .free:
            price = "免费"
        case .lock:
            price = "\(model.gameInfo?.unlockCoin ?? 100)"
        case .again, .task:
            price = "\(model.gameInfo?.unitCoin ?? 5)/次"
        }
        let mutAttr = NSMutableAttributedString(string: price, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0xFFED3C), NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(20))])
        if self == .again || self == .task || self == .free {
            mutAttr.addAttributes([NSAttributedString.Key.font : UIFont.pfSCSemiboldFont(withSize: AdaptSize(12))], range: NSRange(location: price.count - 2, length: 2))
        }
        return mutAttr
    }
}

class YXChallengeStartButton: UIButton {

    var customTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.textAlignment = .center
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
        label.shadowOffset  = CGSize(width: 0, height: 1)
        label.shadowColor   = UIColor.hex(0xE34B0B)
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
        guard let userModel = model.userModel else {
            return
        }

        if userModel.gameStatus == .lock {
            self.customTitleLabel.text = "解锁"
            self.setBackgroundImage(UIImage(named: "challengeLockButton"), for: .normal)
        } else {
            if userModel.ranking == 0 {
                self.customTitleLabel.text = "立即挑战"
            } else {
                self.customTitleLabel.text = "再战一次"
            }
            self.setBackgroundImage(UIImage(named: "challengeButton"), for: .normal)
        }

        switch userModel.gameStatus {
        case .task, .again:
            let priceView = self.getPriceView(model)
            self.addSubview(priceView)
            self.customTitleLabel.sizeToFit()
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(40))
                make.centerY.equalToSuperview().offset(AdaptSize(-3))
                make.size.equalTo(customTitleLabel.size)
            }
            priceView.snp.makeConstraints { (make) in
                make.left.equalTo(customTitleLabel.snp.right)
                make.centerY.equalTo(customTitleLabel)
                make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(28)))
            }
        case .free:
            let priceView = self.getPriceView(model)
            self.addSubview(priceView)
            self.customTitleLabel.sizeToFit()
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(40))
                make.centerY.equalToSuperview().offset(AdaptSize(-3))
                make.size.equalTo(customTitleLabel.size)
            }
            priceView.snp.makeConstraints { (make) in
                make.left.equalTo(customTitleLabel.snp.right)
                make.centerY.equalTo(customTitleLabel)
                make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(28)))
            }
        case .lock:
            let priceView = self.getPriceView(model)
            self.addSubview(priceView)
            self.customTitleLabel.sizeToFit()
            self.customTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(79))
                make.centerY.equalToSuperview().offset(AdaptSize(-3))
                make.size.equalTo(customTitleLabel.size)
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
        guard let userModel = model.userModel else {
            return UIView()
        }
        let priceView = UIView()
        priceView.isUserInteractionEnabled = false
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
            label.attributedText = userModel.gameStatus.getPriceString(model)
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
