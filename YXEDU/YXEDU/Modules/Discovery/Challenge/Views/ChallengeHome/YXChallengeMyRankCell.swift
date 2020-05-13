//
//  YXChallengeMyRankCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeMyRankCell: UIView {
    var bgContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF5E8D6)
        view.layer.cornerRadius = AdaptSize(10)
        return view
    }()

    var tagImageView: UIImageView = {
        let imageView   = UIImageView()
        imageView.image = UIImage(named: "challengeLevelTag")
        return imageView
    }()

    var levelLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var levelHighlightLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.white
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.cornerRadius  = AdaptSize(38/2)
        imageView.layer.borderColor   = UIColor.white.cgColor
        imageView.layer.borderWidth   = AdaptSize(2)
        imageView.layer.masksToBounds = true
        imageView.image               = UIImage(named: "challengeAvatar")
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

    var heraldLabel: UILabel = {
        let label = UILabel()
        label.text          = "活动结束可得"
        label.textColor     = UIColor.red1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
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

    var isPreviousRank: Bool

    init(isPreviousRank: Bool) {
        self.isPreviousRank = isPreviousRank
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ userModel: YXChallengeUserModel) {
        if userModel.challengeResult == .success {
            self.nameLabel.text               = userModel.name
            self.nameLabel.textColor          = UIColor.hex(0x4F381D)
            self.descriptionLabel.text        = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time/1000)
            self.descriptionLabel.textColor   = UIColor.hex(0xA18266)
            self.descriptionLabel.font        = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
            self.heraldLabel.isHidden         = self.isPreviousRank
            self.goldIconImageView.isHidden   = false
            self.bonusLabel.isHidden          = false
            self.descriptionLabel.isHidden    = false
            self.tagImageView.isHidden        = true
            self.levelHighlightLabel.isHidden = true
            self.levelLabel.isHidden          = false
            self.bonusLabel.text              = "+\(userModel.bonus)"
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
            self.levelLabel.text = "\(userModel.ranking)"
            levelLabel.sizeToFit()
            levelLabel.snp.updateConstraints { (make) in
                make.width.equalTo(levelLabel.width)
            }
        } else {
            if userModel.challengeResult == .unanswered {
                self.nameLabel.text            = "本期内尚未参加过挑战"
            } else {
                self.nameLabel.text            = "挑战失败"
            }
            self.nameLabel.textColor           = UIColor.hex(0x4F381D)
            self.descriptionLabel.text         = ""
            self.descriptionLabel.isHidden     = true
            self.heraldLabel.isHidden          = true
            self.goldIconImageView.isHidden    = true
            self.bonusLabel.isHidden           = true
            self.tagImageView.isHidden         = false
            self.levelHighlightLabel.isHidden  = false
            self.levelLabel.isHidden           = true
            self.levelHighlightLabel.text      = "未上榜"
            self.nameLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(avatarImageView)
            }
            self.levelHighlightLabel.sizeToFit()
            self.tagImageView.snp.updateConstraints { (make) in
                make.width.equalTo(AdaptSize(levelHighlightLabel.width + AdaptSize(13)))
            }
        }
        self.avatarImageView.showImage(with: userModel.avatarStr)
        
        self.nameLabel.sizeToFit()
        self.nameLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.nameLabel.width)
        }
    }

    private func setSubviews() {
        self.addSubview(bgContentView)
        bgContentView.addSubview(levelLabel)
        bgContentView.addSubview(avatarImageView)
        bgContentView.addSubview(nameLabel)
        bgContentView.addSubview(descriptionLabel)
        bgContentView.addSubview(heraldLabel)
        bgContentView.addSubview(goldIconImageView)
        bgContentView.addSubview(bonusLabel)
        bgContentView.addSubview(tagImageView)
        tagImageView.addSubview(levelHighlightLabel)

        levelLabel.sizeToFit()
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
            make.width.equalTo(levelLabel.width)
        }
        bgContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(13))
            make.right.equalToSuperview().offset(AdaptSize(-13))
        }

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
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(3))
            make.left.equalTo(nameLabel)
            make.size.equalTo(descriptionLabel.size)
        }

        heraldLabel.sizeToFit()
        heraldLabel.snp.makeConstraints { (make) in
            make.top.centerY.equalTo(nameLabel)
            make.size.equalTo(heraldLabel.size)
            make.right.equalToSuperview().offset(AdaptSize(-12))
        }

        goldIconImageView.snp.makeConstraints { (make) in
            if isPreviousRank {
                make.centerY.equalToSuperview()
            } else {
                make.centerY.equalTo(descriptionLabel)
            }
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
            make.right.equalTo(bonusLabel.snp.left).offset(AdaptSize(-5))
        }

        bonusLabel.sizeToFit()
        bonusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(goldIconImageView)
            make.width.equalTo(bonusLabel.width)
            make.height.equalTo(AdaptSize(21))
            make.right.equalToSuperview().offset(AdaptSize(-14))
        }

    }
}

