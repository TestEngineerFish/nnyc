//
//  YXChallengeRankCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeRankCell: UITableViewCell {

    var leftTopLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: AdaptSize(5), y: 0))
        path.addLine(to: CGPoint(x: AdaptSize(5), y: AdaptSize(6)))
        path.close()
        layer.path = path.cgPath
        layer.fillColor = UIColor.hex(0xCF6900).cgColor
        layer.isHidden = true
        return layer
    }()

    var rightTopLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: AdaptSize(6)))
        path.addLine(to: CGPoint(x: AdaptSize(0), y: 0))
        path.addLine(to: CGPoint(x: AdaptSize(5), y: 0))
        path.close()
        layer.path      = path.cgPath
        layer.fillColor = UIColor.hex(0xCF6900).cgColor
        layer.isHidden = true
        return layer
    }()

    var shadeView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.size     = CGSize(width: AdaptSize(359), height: AdaptSize(81))
        view.layer.setGradient(colors: [UIColor.hex(0xFDB832), UIColor.orange1], direction: .vertical)
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(6))
        return view
    }()

    var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF4EEE2)
        return view
    }()

    var tagImageView: UIImageView = {
        let imageView   = UIImageView()
        imageView.image = UIImage(named: "challengeLevelTag")
        return imageView
    }()

    var levelHighlightLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.hex(0xFFF039)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var levelLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.orange1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.cornerRadius = AdaptSize(AdaptSize(38/2))
        imageView.layer.borderColor  = UIColor.white.cgColor
        imageView.layer.borderWidth  = AdaptSize(2)
        imageView.image              = UIImage(named: "reportSpeedPlatf")
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var goldIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()

    var bonusLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.hex(0xEE531A)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.hex(0xE9DDC4)
        self.selectionStyle = .none
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ==== Update UI ====
    /// 显示遮罩
    func showCnallengeResultView(_ userModel: YXChallengeUserModel) {
        self.shadeView.isHidden     = false
        self.levelLabel.isHidden    = true
        self.customContentView.backgroundColor = .clear
        switch userModel.challengeResult {
        case .success:
            self.nameLabel.text           = userModel.name
            self.descriptionLabel.text    = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time)
            self.nameLabel.textColor        = UIColor.white
            self.descriptionLabel.textColor = UIColor.white
            self.goldIconImageView.isHidden = false
            self.bonusLabel.isHidden        = false
            self.goldIconImageView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: AdaptSize(28), height: AdaptSize(28)))
            }
        case .fail:
            self.nameLabel.text             = "挑战失败"
            self.descriptionLabel.text      = "别灰心，再接再厉哦"
            self.nameLabel.textColor        = UIColor.hex(0xFFF7EB)
            self.descriptionLabel.textColor = UIColor.hex(0xFFF7EB)
            self.goldIconImageView.isHidden = true
            self.bonusLabel.isHidden        = true
            self.shadeView.layer.setGradient(colors: [UIColor.hex(0xFADEA8), UIColor.hex(0xB29568)], direction: .vertical)
        case .notList:
            self.nameLabel.text             = "本期内尚未完成过学习计划"
            self.descriptionLabel.text      = "无法参加挑战"
            self.nameLabel.textColor        = UIColor.hex(0xFFF7EB)
            self.descriptionLabel.textColor = UIColor.hex(0xFFF7EB)
            self.goldIconImageView.isHidden = true
            self.bonusLabel.isHidden        = true
            self.shadeView.layer.setGradient(colors: [UIColor.hex(0xFADEA8), UIColor.hex(0xB29568)], direction: .vertical)
        }

        self.avatarImageView.layer.cornerRadius = AdaptSize(47/2)
        self.avatarImageView.snp.updateConstraints { (make) in
            make.width.equalTo(AdaptSize(47))
            make.height.equalTo(AdaptSize(47))
        }
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.nameLabel.width)
        }
        self.descriptionLabel.sizeToFit()
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.descriptionLabel.width)
        }
    }

    /// 显示尖角
    func showArrowLayer(_ userModel: YXChallengeUserModel) {
        self.leftTopLayer.isHidden  = false
        self.rightTopLayer.isHidden = false
        switch userModel.challengeResult {
        case .success:
            self.leftTopLayer.fillColor = UIColor.hex(0xCF6900).cgColor
            self.rightTopLayer.fillColor = UIColor.hex(0xCF6900).cgColor
        case .fail, .notList:
            self.leftTopLayer.fillColor = UIColor.hex(0xA47528).cgColor
            self.rightTopLayer.fillColor = UIColor.hex(0xA47528).cgColor
        }
    }

    /// 显示底部圆角
    func showBottomRadius() {
        self.customContentView.clipRectCorner(directionList: [.bottomLeft, .bottomRight], cornerRadius: AdaptSize(14))
    }

    func bindData(_ userModel: YXChallengeUserModel) {
        self.levelHighlightLabel.text = "\(userModel.ranking)"
        self.levelLabel.text          = "\(userModel.ranking)"
        self.nameLabel.text           = userModel.name
        self.descriptionLabel.text    = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time)
        self.bonusLabel.text          = "+\(userModel.bonus)"
        self.avatarImageView.showImage(with: userModel.avatarStr)

        self.levelHighlightLabel.sizeToFit()
        self.tagImageView.snp.updateConstraints { (make) in
            make.width.equalTo(AdaptSize(levelHighlightLabel.width + 13))
        }
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.nameLabel.width)
        }
        self.descriptionLabel.sizeToFit()
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.descriptionLabel.width)
        }
        self.bonusLabel.sizeToFit()
        self.bonusLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.bonusLabel.width)
        }
    }

    private func setSubviews() {
        self.contentView.addSubview(shadeView)
        self.contentView.addSubview(customContentView)
        self.contentView.layer.addSublayer(leftTopLayer)
        self.contentView.layer.addSublayer(rightTopLayer)

        shadeView.addSubview(tagImageView)
        tagImageView.addSubview(levelHighlightLabel)

        customContentView.addSubview(levelLabel)
        customContentView.addSubview(avatarImageView)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(descriptionLabel)
        customContentView.addSubview(goldIconImageView)
        customContentView.addSubview(bonusLabel)

        customContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(13))
            make.right.equalToSuperview().offset(AdaptSize(-13))
        }

        leftTopLayer.frame = CGRect(x: AdaptSize(8), y: 0, width: AdaptSize(5), height: AdaptSize(6))
        rightTopLayer.frame = CGRect(x: AdaptSize(362), y: 0, width: AdaptSize(5), height: AdaptSize(6))

        shadeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(8))
            make.right.equalToSuperview().offset(AdaptSize(-8))
            make.top.bottom.equalToSuperview()
        }

        levelHighlightLabel.sizeToFit()
        tagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(12))
            make.width.equalTo(AdaptSize(levelHighlightLabel.width + 13))
            make.height.equalTo(AdaptSize(19))
        }

        levelHighlightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-8))
        }

        levelLabel.sizeToFit()
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
            make.width.equalTo(levelLabel.width)
        }

        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AdaptSize(38))
            make.height.equalTo(AdaptSize(38))
            make.left.equalToSuperview().offset(AdaptSize(47))
        }

        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView).offset(-AdaptSize(10))
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(16))
            make.width.equalTo(nameLabel.width)
            make.height.equalTo(AdaptSize(20))
        }

        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(nameLabel)
            make.width.equalTo(descriptionLabel.width)
            make.height.equalTo(AdaptSize(17))
        }

        goldIconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(19), height: AdaptSize(19)))
            make.right.equalTo(bonusLabel.snp.left).offset(AdaptSize(-5))
        }

        bonusLabel.sizeToFit()
        bonusLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(bonusLabel.width)
            make.height.equalTo(AdaptSize(21))
            make.right.equalToSuperview().offset(AdaptSize(-14))
        }

    }
}
