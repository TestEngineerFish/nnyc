//
//  YXPreviousResultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXPreviousResultView: UIView {

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    var resultBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "previousRankBackground")
        return imageView
    }()
    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.image               = UIImage(named: "challengeAvatar")
        imageView.layer.borderWidth   = AdaptIconSize(2)
        imageView.layer.borderColor   = UIColor.white.cgColor
        imageView.layer.cornerRadius  = AdaptIconSize(24)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "上期挑战排名"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .center
        return label
    }()
    var rankLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x834A11)
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))
        label.textAlignment = .center
        return label
    }()
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.hex(0xF3D2B1)
        view.layer.cornerRadius = AdaptSize(12)
        view.layer.borderColor  = UIColor.hex(0xFFF0E2).cgColor
        view.layer.borderWidth  = AdaptSize(1)
        return view
    }()
    var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "答对"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "用时"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var coinTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "获得松果币"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()
    var questionAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var timeAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var coinAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    var gainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gameResultFailButton"), for: .normal)
        button.setTitleColor(UIColor.hex(0xD9552E), for: .normal)
        button.titleLabel?.font = UIFont.semiboldFont(ofSize: AdaptFontSize(17))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindProperty() {
        self.gainButton.addTarget(self, action: #selector(hideView), for: .touchUpInside)
    }

    private func createSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(resultBackgroundImageView)
        resultBackgroundImageView.addSubview(avatarImageView)
        resultBackgroundImageView.addSubview(titleLabel)
        resultBackgroundImageView.addSubview(rankLabel)
        resultBackgroundImageView.addSubview(contentView)
        contentView.addSubview(questionTitleLabel)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(coinTitleLabel)
        contentView.addSubview(questionAmountLabel)
        contentView.addSubview(timeAmountLabel)
        contentView.addSubview(coinAmountLabel)
        self.addSubview(gainButton)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        resultBackgroundImageView.snp.makeConstraints { (make) in
            make.width.equalTo(AdaptIconSize(375))
            make.height.equalTo(AdaptIconSize(485))
            make.centerY.equalToSuperview().offset(AdaptIconSize(-50))
            make.centerX.equalToSuperview()
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptIconSize(217))
            make.size.equalTo(CGSize(width: AdaptIconSize(48), height: AdaptIconSize(48)))
        }
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptIconSize(4))
            make.size.equalTo(titleLabel.size)
        }
        rankLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(28))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(3))
            make.width.equalTo(0)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(rankLabel.snp.bottom).offset(AdaptIconSize(15))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptIconSize(242), height: AdaptIconSize(76)))
        }
        questionTitleLabel.sizeToFit()
        questionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(15))
            make.size.equalTo(questionTitleLabel.size)
            make.top.equalToSuperview().offset(AdaptSize(isPad() ? 20 : 11))
        }
        timeTitleLabel.sizeToFit()
        timeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(75))
            make.top.equalTo(questionTitleLabel)
            make.size.equalTo(timeTitleLabel.size)
        }
        coinTitleLabel.sizeToFit()
        coinTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(164))
            make.top.equalTo(questionTitleLabel)
            make.size.equalTo(coinTitleLabel.size)
        }
        questionAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(questionTitleLabel)
            make.top.equalTo(questionTitleLabel.snp.bottom).offset(AdaptIconSize(2))
            make.height.equalTo(AdaptSize(28))
            make.width.equalTo(0)
        }
        timeAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeTitleLabel)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(AdaptIconSize(2))
            make.height.equalTo(AdaptSize(28))
            make.width.equalTo(0)
        }
        coinAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coinTitleLabel)
            make.top.equalTo(coinTitleLabel.snp.bottom).offset(AdaptIconSize(2))
            make.height.equalTo(AdaptSize(28))
            make.width.equalTo(0)
        }
        gainButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptIconSize(204), height: AdaptIconSize(50)))
            make.top.equalTo(resultBackgroundImageView.snp.bottom).offset(AdaptSize(-10))
            make.centerX.equalToSuperview()
        }
    }

    func bindData(_ userModel: YXChallengeUserModel) {
        if !userModel.avatarStr.isEmpty {
            self.avatarImageView.showImage(with: userModel.avatarStr)
        }
        rankLabel.text = "\(userModel.ranking)"
        let questionValue = String(format: "%ld", userModel.questionCount)
        let timeValue     = String(format: "%0.2f", userModel.time / 1000)
        let coinValue     = String(format: "%ld", userModel.bonus)
        let questionMAttr = NSMutableAttributedString(string: questionValue + "题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x834A11), NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(12))])
        questionMAttr.addAttributes([NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))], range: NSRange(location: 0, length: questionValue.count))
        let timeMAttr     = NSMutableAttributedString(string: timeValue + "秒", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x834A11), NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(12))])
        timeMAttr.addAttributes([NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))], range: NSRange(location: 0, length: timeValue.count))
        let coinMAttr     = NSMutableAttributedString(string: coinValue + "个", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x834A11), NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(12))])
        coinMAttr.addAttributes([NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))], range: NSRange(location: 0, length: coinValue.count))
        questionAmountLabel.attributedText = questionMAttr
        timeAmountLabel.attributedText     = timeMAttr
        coinAmountLabel.attributedText     = coinMAttr
        rankLabel.sizeToFit()
        questionAmountLabel.sizeToFit()
        timeAmountLabel.sizeToFit()
        coinAmountLabel.sizeToFit()
        rankLabel.snp.updateConstraints { (make) in
            make.width.equalTo(rankLabel.width)
        }
        questionAmountLabel.snp.updateConstraints { (make) in
            make.width.equalTo(questionAmountLabel.width)
        }
        timeAmountLabel.snp.updateConstraints { (make) in
            make.width.equalTo(timeAmountLabel.width)
        }
        coinAmountLabel.snp.updateConstraints { (make) in
            make.width.equalTo(coinAmountLabel.width)
        }
    }

    // MARK: ==== Event ====
    @objc private func hideView() {
        self.removeFromSuperview()
    }
}
