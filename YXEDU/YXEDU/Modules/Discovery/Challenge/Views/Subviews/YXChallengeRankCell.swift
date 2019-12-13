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
        imageView.layer.cornerRadius = AdaptSize(AdaptSize(47))
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

    var awardLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.hex(0xEE531A)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showBorderView() {

    }

    func bindData(_ model: YXChallengeUserModel) {

    }

    private func setSubviews() {
        self.contentView.addSubview(customContentView)
        self.contentView.layer.addSublayer(leftTopLayer)
        self.contentView.layer.addSublayer(rightTopLayer)
        self.contentView.addSubview(shadeView)

        shadeView.addSubview(tagImageView)
        tagImageView.addSubview(levelHighlightLabel)

        customContentView.addSubview(levelLabel)
        customContentView.addSubview(avatarImageView)
        customContentView.addSubview(nameLabel)
        customContentView.addSubview(descriptionLabel)
        customContentView.addSubview(goldIconImageView)
        customContentView.addSubview(awardLabel)

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

        tagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(12))
            make.width.equalTo(AdaptSize(46))
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
            make.top.equalTo(avatarImageView)
            make.height.equalTo(avatarImageView).multipliedBy(0.5)
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(16))
            make.width.equalTo(nameLabel)
        }

        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(nameLabel)
            make.width.equalTo(descriptionLabel.width)
            make.height.equalTo(avatarImageView).multipliedBy(0.5)
        }

        goldIconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(19), height: AdaptSize(19)))
            make.right.equalTo(awardLabel.snp.left)
        }

        awardLabel.sizeToFit()
        awardLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(awardLabel.width)
            make.height.equalTo(AdaptSize(21))
            make.left.equalToSuperview().offset(AdaptSize(-14))
        }

    }
}
