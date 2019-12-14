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
        imageView.image = UIImage(named: "")
        return imageView
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.image = UIImage(named: "reportSpeedPlatf")
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pfSCMediumFont(withSize: AdaptSize(14))
        label.textColor = UIColor.black1
        label.textAlignment = .center
        return label
    }()

    var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "答题"
        label.font = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textColor = UIColor.black3
        label.textAlignment = .center
        return label
    }()

    var questionCountLabel: UILabel = {
        let label = UILabel()
        label.text = "--个"
        label.font = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textColor = UIColor.orange1
        label.textAlignment = .center
        return label
    }()

    var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()

    var consumeTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "耗时"
        label.font = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textColor = UIColor.black3
        label.textAlignment = .center
        return label
    }()

    var consumeTimeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "--秒"
        label.font = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textColor = UIColor.orange1
        label.textAlignment = .center
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
        self.nameLabel.text             = model.name
        self.questionCountLabel.text    = "\(model.questionCount)个"
        self.consumeTimeCountLabel.text = "\(model.time)秒"
        self.setNeedsLayout()
    }

    private func setSubviews(_ level: YXChallengeRankLevel) {
        self.addSubview(crownImageView)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(questionTitleLabel)
        self.addSubview(questionCountLabel)
        self.addSubview(separateView)
        self.addSubview(consumeTimeTitleLabel)
        self.addSubview(consumeTimeCountLabel)

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
                make.size.equalTo(CGSize(width: AdaptSize(85), height: AdaptSize(94)))
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
            make.bottom.equalTo(separateView.snp.top).offset(AdaptSize(-7))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(20))
        }

        separateView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize(-3))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(1), height: AdaptSize(26)))
        }

        questionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(questionCountLabel.snp.top)
            make.height.equalTo(AdaptSize(17))
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        questionCountLabel.sizeToFit()
        questionCountLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(17))
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        consumeTimeTitleLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalTo(consumeTimeCountLabel.snp.top)
            make.height.equalTo(AdaptSize(17))
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        consumeTimeCountLabel.sizeToFit()
        consumeTimeCountLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(17))
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

}
