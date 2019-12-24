//
//  YXChallengeRankTop3View.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXChallengeRankLevel {
    case first
    case second
    case third
}

class YXChallengeRankTopView: UIView {

    var crownImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        return imageView
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.image = UIImage(named: "challengeAvatar")
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "- -"
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(14))
        label.textColor     = UIColor.black1
        label.textAlignment = .center
        return label
    }()

    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        view.isHidden        = true
        return view
    }()

    var questionLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textColor     = UIColor.black3
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()

    var consumeTimeLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textColor     = UIColor.black3
        label.textAlignment = .left
        label.isHidden      = true
        return label
    }()

    var goldIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeGoldIcon")
        imageView.isHidden = true
        return imageView
    }()

    var bonusLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0xEE531A)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    init(_ level: YXChallengeRankLevel) {
        super.init(frame: CGRect.zero)
        self.setSubviews(level)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXChallengeUserModel) {
        self.avatarImageView.showImage(with: model.avatarStr)
        self.nameLabel.text        = model.name
        self.questionLabel.text    = "答题 \(model.questionCount)个"
        self.consumeTimeLabel.text = "耗时 \(model.time)秒"
        self.bonusLabel.text       = "+\(model.bonus)"
        goldIconImageView.isHidden = false
        bonusLabel.isHidden        = false
        separateView.isHidden      = false
        questionLabel.isHidden     = false
        consumeTimeLabel.isHidden  = false
        self.setNeedsLayout()
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.bonusLabel.sizeToFit()
        self.bonusLabel.snp.updateConstraints { (make) in
            make.width.equalTo(self.bonusLabel.width)
        }
    }

    private func setSubviews(_ level: YXChallengeRankLevel) {
        self.addSubview(crownImageView)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(goldIconImageView)
        self.addSubview(bonusLabel)
        self.addSubview(questionLabel)
        self.addSubview(separateView)
        self.addSubview(consumeTimeLabel)

        switch level {
        case .first:
            crownImageView.image = UIImage(named: "challengeFirst")
        case .second:
            crownImageView.image = UIImage(named: "challengeSecond")
        case .third:
            crownImageView.image = UIImage(named: "challengeThird")
        }

        if level == .first {
            crownImageView.image = UIImage(named: "challengeFirst")
            avatarImageView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(AdaptSize(22))
                make.size.equalTo(CGSize(width: AdaptSize(70), height: AdaptSize(70)))
            }
            crownImageView.snp.makeConstraints { (make) in
                make.left.equalTo(avatarImageView).offset(AdaptSize(-4))
                make.bottom.equalTo(avatarImageView).offset(AdaptSize(4))
                make.size.equalTo(CGSize(width: AdaptSize(87), height: AdaptSize(97)))
            }
        } else {
            avatarImageView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(AdaptSize(18))
                make.size.equalTo(CGSize(width: AdaptSize(59), height: AdaptSize(59)))
            }
            crownImageView.snp.makeConstraints { (make) in
                make.left.equalTo(avatarImageView).offset(AdaptSize(-3))
                make.bottom.equalTo(avatarImageView).offset(AdaptSize(3))
                make.size.equalTo(CGSize(width: AdaptSize(74), height: AdaptSize(80)))
            }
        }

        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-50))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(20))
        }

        bonusLabel.sizeToFit()
        bonusLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(3))
            make.width.equalTo(bonusLabel.width)
            make.height.equalTo(AdaptSize(17))
            make.bottom.equalToSuperview()
        }

        goldIconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(17.64), height: AdaptSize(18.34)))
            make.centerX.equalTo(bonusLabel)
            make.bottom.equalTo(bonusLabel.snp.top)
        }

        separateView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(bonusLabel.snp.right).offset(AdaptSize(3))
            make.size.equalTo(CGSize(width: AdaptSize(1), height: AdaptSize(26)))
        }

        questionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(separateView.snp.right).offset(AdaptSize(3))
            make.right.equalToSuperview().offset(AdaptSize(-3))
            make.top.equalTo(goldIconImageView)
            make.height.equalTo(AdaptSize(17))
        }

        consumeTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(separateView.snp.right).offset(AdaptSize(3))
            make.right.equalToSuperview().offset(AdaptSize(-3))
            make.top.equalTo(questionLabel.snp.bottom)
            make.height.equalTo(AdaptSize(17))
        }
    }

}
