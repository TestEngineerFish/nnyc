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
        view.backgroundColor = UIColor.hex(0xF4EEE2)
        return view
    }()

    var levelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()

    var levelLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.orange1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(15))
        label.textAlignment = .center
        return label
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.cornerRadius = AdaptSize(38/2)
        imageView.layer.borderColor  = UIColor.white.cgColor
        imageView.layer.borderWidth  = AdaptSize(2)
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(14))
        label.textAlignment = .center
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
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
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptFontSize(15))
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ userModel: YXChallengeUserModel) {
        self.nameLabel.text           = userModel.name
        self.descriptionLabel.text    = String(format: "答题：%d  耗时：%0.2f秒", userModel.questionCount, userModel.time/1000)
        self.bonusLabel.text          = "+\(userModel.bonus)"
        let defaultImage = UIImage(named: "challengeAvatar")
        if userModel.avatarStr.isEmpty {
            self.avatarImageView.image = defaultImage
        } else {
            YXKVOImageView().showImage(with: userModel.avatarStr, placeholder: defaultImage, progress: nil) { [weak self] (image: UIImage?, error: NSError?, url: NSURL?) in
                guard let self = self else { return }
                self.avatarImageView.image = image?.corner(radius: AdaptIconSize(19), with: self.avatarImageView.size)
            }
        }
        if userModel.ranking <= 3 {
            self.levelLabel.isHidden     = true
            self.levelImageView.isHidden = false
            self.levelImageView.image    = UIImage(named: "challengeRanking\(userModel.ranking)")
        } else {
            self.levelLabel.isHidden     = false
            self.levelImageView.isHidden = true
            self.levelLabel.text          = "\(userModel.ranking)"
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

    private func createSubviews() {
        self.addSubview(bgContentView)
        bgContentView.addSubview(levelLabel)
        bgContentView.addSubview(levelImageView)
        bgContentView.addSubview(avatarImageView)
        bgContentView.addSubview(nameLabel)
        bgContentView.addSubview(descriptionLabel)
        bgContentView.addSubview(goldIconImageView)
        bgContentView.addSubview(bonusLabel)
        let margin = isPad() ? AdaptSize(60) : AdaptSize(13)
        bgContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(margin)
            make.right.equalToSuperview().offset(-margin)
        }

        levelLabel.sizeToFit()
        levelLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(levelImageView)
            make.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
            make.width.equalTo(levelLabel.width)
        }
        levelImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(8))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptIconSize(25), height: AdaptIconSize(22)))
        }
        avatarImageView.size = CGSize(width: AdaptIconSize(38), height: AdaptIconSize(38))
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(AdaptIconSize(38))
            make.height.equalTo(AdaptIconSize(38))
            make.left.equalToSuperview().offset(AdaptIconSize(47))
        }

        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(avatarImageView.snp.centerY)
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(16))
            make.width.equalTo(nameLabel.width)
            make.height.equalTo(nameLabel.height)
        }

        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(nameLabel)
            make.width.equalTo(descriptionLabel.width)
            make.height.equalTo(descriptionLabel.height)
        }

        goldIconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptIconSize(20), height: AdaptIconSize(20)))
            make.right.equalTo(bonusLabel.snp.left).offset(AdaptIconSize(-5))
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
