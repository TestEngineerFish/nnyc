//
//  YXChallengeMyRankCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeMyRankCell: UITableViewCell {

    var leftTopLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: AdaptSize(5), y: 0))
        path.addLine(to: CGPoint(x: AdaptSize(5), y: AdaptSize(6)))
        path.close()
        layer.path = path.cgPath
        layer.fillColor = UIColor.hex(0xCF6900).cgColor
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
        return layer
    }()

    var shadowView: UIView =  {
        let view = UIView()
        view.size     = CGSize(width: AdaptSize(359), height: AdaptSize(81))
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(6))
        return view
    }()

    var bgContentView: UIView = {
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

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.cornerRadius = AdaptSize(38/2)
        imageView.layer.borderColor  = UIColor.white.cgColor
        imageView.layer.borderWidth  = AdaptSize(2)
        imageView.image              = UIImage(named: "challengeAvatar")
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

    func bindData(_ userModel: YXChallengeUserModel) {

        switch userModel.challengeResult {
        case .success:
            self.nameLabel.text             = userModel.name
            self.nameLabel.textColor        = UIColor.white
            self.descriptionLabel.text      = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time)
            self.descriptionLabel.textColor = UIColor.white
            self.descriptionLabel.font      = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
            self.goldIconImageView.isHidden = false
            self.bonusLabel.isHidden        = false
            self.descriptionLabel.isHidden  = false
            self.leftTopLayer.fillColor     = UIColor.hex(0xCF6900).cgColor
            self.rightTopLayer.fillColor    = UIColor.hex(0xCF6900).cgColor
            self.bonusLabel.text            = "+\(userModel.bonus)"
            self.levelHighlightLabel.text   = "\(userModel.ranking)"
            self.levelHighlightLabel.font   = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
            self.shadowView.layer.setGradient(colors: [UIColor.hex(0xFDB832), UIColor.orange1], direction: .vertical)
            self.descriptionLabel.sizeToFit()
            self.descriptionLabel.snp.updateConstraints { (make) in
                make.width.equalTo(self.descriptionLabel.width)
            }
            self.nameLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(avatarImageView).offset(-AdaptSize(10))
            }
            self.bonusLabel.sizeToFit()
            self.bonusLabel.snp.updateConstraints { (make) in
                make.width.equalTo(self.bonusLabel.width)
            }
        case .unanswered:
            self.nameLabel.text                = "本期内尚未完成过学习计划"
            self.nameLabel.textColor           = UIColor.hex(0xFFF7EB)
            self.descriptionLabel.text         = ""
            self.descriptionLabel.isHidden     = true
            self.goldIconImageView.isHidden    = true
            self.bonusLabel.isHidden           = true
            self.leftTopLayer.fillColor        = UIColor.hex(0xA47528).cgColor
            self.rightTopLayer.fillColor       = UIColor.hex(0xA47528).cgColor
            self.levelHighlightLabel.text      = "未上榜"
            self.levelHighlightLabel.font      = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
            self.levelHighlightLabel.textColor = UIColor.hex(0xB3A394)
            self.tagImageView.image            = UIImage(named: "challengeLevelTag2")
            self.shadowView.layer.setGradient(colors: [UIColor.hex(0xFADEA8), UIColor.hex(0xB29568)], direction: .vertical)
            self.nameLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(avatarImageView)
            }
        case .fail:
            self.nameLabel.text                = "挑战失败"
            self.nameLabel.textColor           = UIColor.hex(0xFFF7EB)
            self.descriptionLabel.text         = "别灰心，再接再厉哦"
            self.descriptionLabel.isHidden     = false
            self.descriptionLabel.font         = UIFont.regularFont(ofSize: AdaptSize(12))
            self.descriptionLabel.textColor    = UIColor.hex(0xFFF7EB)
            self.goldIconImageView.isHidden    = true
            self.bonusLabel.isHidden           = true
            self.leftTopLayer.fillColor        = UIColor.hex(0xA47528).cgColor
            self.rightTopLayer.fillColor       = UIColor.hex(0xA47528).cgColor
            self.levelHighlightLabel.text      = "未上榜"
            self.levelHighlightLabel.font      = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
            self.levelHighlightLabel.textColor = UIColor.hex(0xB3A394)
            self.tagImageView.image            = UIImage(named: "challengeLevelTag2")
            self.shadowView.layer.setGradient(colors: [UIColor.hex(0xFADEA8), UIColor.hex(0xB29568)], direction: .vertical)
            self.descriptionLabel.sizeToFit()
            self.descriptionLabel.snp.updateConstraints { (make) in
                make.width.equalTo(descriptionLabel.width)
            }
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
        self.levelHighlightLabel.sizeToFit()
        self.tagImageView.snp.updateConstraints { (make) in
            make.width.equalTo(AdaptSize(levelHighlightLabel.width + AdaptSize(13)))
        }
    }

    private func setSubviews() {
        self.contentView.addSubview(bgContentView)
        self.contentView.addSubview(shadowView)
        self.contentView.layer.addSublayer(leftTopLayer)
        self.contentView.layer.addSublayer(rightTopLayer)

        shadowView.addSubview(avatarImageView)
        shadowView.addSubview(nameLabel)
        shadowView.addSubview(descriptionLabel)
        shadowView.addSubview(goldIconImageView)
        shadowView.addSubview(bonusLabel)
        shadowView.addSubview(tagImageView)
        tagImageView.addSubview(levelHighlightLabel)

        bgContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(13))
            make.right.equalToSuperview().offset(AdaptSize(-13))
        }

        shadowView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(8))
            make.right.equalToSuperview().offset(AdaptSize(-8))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-6))
        }
        leftTopLayer.frame  = CGRect(x: AdaptSize(8), y: AdaptSize(81), width: AdaptSize(5), height: AdaptSize(6))
        rightTopLayer.frame = CGRect(x: screenWidth - AdaptSize(13), y: AdaptSize(81), width: AdaptSize(5), height: AdaptSize(6))

        levelHighlightLabel.sizeToFit()
        tagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(12))
            make.width.equalTo(AdaptSize(levelHighlightLabel.width + AdaptSize(13)))
            make.height.equalTo(AdaptSize(19))
        }

        levelHighlightLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-8))
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
            make.size.equalTo(CGSize(width: AdaptSize(28), height: AdaptSize(28)))
            make.right.equalTo(bonusLabel.snp.left).offset(AdaptSize(-5))
        }

        bonusLabel.sizeToFit()
        bonusLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(bonusLabel.width)
            make.height.equalTo(AdaptSize(21))
            make.right.equalToSuperview().offset(AdaptSize(-19))
        }

    }
}

