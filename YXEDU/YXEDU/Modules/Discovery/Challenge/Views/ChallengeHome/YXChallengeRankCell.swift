//
//  YXChallengeRankCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeRankCell: UITableViewCell {

    var bgContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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
        label.textColor     = UIColor.black3
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

        self.levelLabel.text          = "\(userModel.ranking)"
        self.nameLabel.text           = userModel.name
        self.descriptionLabel.text    = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time/1000)
        self.bonusLabel.text          = "+\(userModel.bonus)"
        self.avatarImageView.showImage(with: userModel.avatarStr)

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
        self.contentView.addSubview(bgContentView)
        bgContentView.addSubview(levelLabel)
        bgContentView.addSubview(avatarImageView)
        bgContentView.addSubview(nameLabel)
        bgContentView.addSubview(descriptionLabel)
        bgContentView.addSubview(goldIconImageView)
        bgContentView.addSubview(bonusLabel)

        bgContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(13))
            make.right.equalToSuperview().offset(AdaptSize(-13))
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
        avatarImageView.layer.cornerRadius  = AdaptSize(19)
        avatarImageView.layer.masksToBounds = true

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
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
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
