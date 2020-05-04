//
//  YXGameResultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXGameResultView: UIView {

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()

    var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.image = UIImage(named: "challengeAvatar")
        imageView.layer.cornerRadius  = AdaptSize(47/2)
        imageView.layer.borderWidth   = AdaptSize(2)
        imageView.layer.borderColor   = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()

    var rankingTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "排名"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()

    var rankingLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x834A11)
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))
        label.textAlignment = .center
        return label
    }()

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor   = UIColor.hex(0xF3D2B1)
        view.layer.cornerRadius = AdaptSize(12)
        view.layer.borderColor  = UIColor.hex(0xFFF0E2).cgColor
        view.layer.borderWidth  = AdaptSize(1)
        return view
    }()

    var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "答对"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()

    var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()

    var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "用时"
        label.textColor     = UIColor.hex(0xA0774E)
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x834A11)
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(24))
        label.textAlignment = .left
        return label
    }()

    // TODO: ---- 失败视图独有

    var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "gameResultFailButton"), for: .normal)
        button.isEnabled = true
        return button
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "不要灰心，下次再来哦"
        label.textColor     = UIColor.hex(0x834A11)
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var closeBlock: (()->Void)?

    func showSuccessView(_ model: YXGameResultModel) {

        avatarImageView.showImage(with: YXUserModel.default.userAvatarPath ?? "")
        resultImageView.image = UIImage(named: "gameResultSuccessBgImage")
        rankingLabel.text = "\(model.ranking)"
        let questionStr = "\(model.questionNumber)题"
        let mAttrRanking = NSMutableAttributedString(string:questionStr, attributes: [NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(24)), NSAttributedString.Key.foregroundColor : UIColor.hex(0x834A11)])
        mAttrRanking.addAttributes([NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(12))], range: NSRange(location: questionStr.count - 1, length: 1))
        questionLabel.attributedText = mAttrRanking

        let timeStr = String(format: "%0.2f秒", Float(model.consumeTime) / 1000)
        let mAttrTime = NSMutableAttributedString(string:timeStr, attributes: [NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(24)), NSAttributedString.Key.foregroundColor : UIColor.hex(0x834A11)])
        mAttrTime.addAttributes([NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: AdaptFontSize(12))], range: NSRange(location: timeStr.count - 1, length: 1))
        timeLabel.attributedText = mAttrTime


        kWindow.addSubview(backgroundView)
        kWindow.addSubview(resultImageView)
        resultImageView.addSubview(avatarImageView)
        resultImageView.addSubview(rankingTitleLabel)
        resultImageView.addSubview(rankingLabel)
        resultImageView.addSubview(contentView)
        contentView.addSubview(questionTitleLabel)
        contentView.addSubview(questionLabel)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(timeLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        resultImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(375), height: AdaptSize(485)))
            make.centerY.equalToSuperview().offset(AdaptSize(-70))
            make.centerX.equalToSuperview()
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(217))
            make.size.equalTo(CGSize(width: AdaptSize(47), height: AdaptSize(47)))
        }
        rankingTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom)
            make.size.equalTo(CGSize(width: AdaptSize(29), height: AdaptSize(20)))
        }
        rankingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(28))
            make.top.equalTo(rankingTitleLabel.snp.bottom)
        }
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(rankingLabel.snp.bottom).offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(176), height: AdaptSize(76)))
        }
        questionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(21))
            make.top.equalToSuperview().offset(AdaptSize(11))
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(20)))
        }
        timeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(93))
            make.top.size.equalTo(questionTitleLabel)
        }
        questionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(questionTitleLabel)
            make.top.equalTo(questionTitleLabel.snp.bottom).offset(AdaptSize(2))
            make.right.equalTo(timeLabel.snp.left).offset(AdaptSize(5))
            make.height.equalTo(AdaptSize(28))
        }
        timeLabel.sizeToFit()
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeTitleLabel)
            make.top.height.equalTo(questionLabel)
            make.width.equalTo(timeLabel.width)
        }
    }

    func showFailView(_ block: (()->Void)?) {
        self.closeBlock = block
        resultImageView.image = UIImage(named: "gameResultFailBgImage")

        kWindow.addSubview(backgroundView)
        kWindow.addSubview(resultImageView)
        resultImageView.addSubview(closeButton)
        resultImageView.addSubview(descriptionLabel)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        resultImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(358), height: AdaptSize(498)))
            make.centerY.equalToSuperview().offset(AdaptSize(-40))
            make.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(AdaptSize(-171))
            make.size.equalTo(CGSize(width: AdaptSize(190), height: AdaptSize(50)))
            make.centerX.equalToSuperview()
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(closeButton.snp.top).offset(AdaptSize(-33))
            make.size.equalTo(descriptionLabel.size)
            make.centerX.equalToSuperview()
        }
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }

    @objc private func clickCloseButton() {
        self.closeBlock?()
    }

    @objc func closeView() {
        self.backgroundView.removeFromSuperview()
        self.resultImageView.removeFromSuperview()
    }
}
