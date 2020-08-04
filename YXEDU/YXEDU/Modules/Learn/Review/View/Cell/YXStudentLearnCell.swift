//
//  YXStudentLearnCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/28.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXStudentLearnCell: UICollectionViewCell {

    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.setDefaultShadow()
        return view
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.cornerRadius  = AdaptIconSize(25)
        return imageView
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = "--"
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(16))
        label.textAlignment = .center
        return label
    }()
    var listenLabel: UILabel = {
        let label = UILabel()
        label.text          = "听写"
        label.textColor     = UIColor.gray3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()
    var reviewLabel: UILabel = {
        let label = UILabel()
        label.text          = "复习"
        label.textColor     = UIColor.gray3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()

    var listenResultLabel: UILabel = {
        let label = UILabel()
        label.text          = "尚未完成"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()
    var reviewResultLabel: UILabel = {
        let label = UILabel()
        label.text          = "尚未完成"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()
    var listenStarView = YXStarView()
    var reviewStarView = YXStarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(bgView)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(listenLabel)
        self.addSubview(reviewLabel)
        self.addSubview(listenResultLabel)
        self.addSubview(reviewResultLabel)
        self.addSubview(listenStarView)
        self.addSubview(reviewStarView)

        bgView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptIconSize(5))
            make.bottom.right.equalToSuperview().offset(AdaptIconSize(-5))
        }
        avatarImageView.size = CGSize(width: AdaptIconSize(50), height: AdaptIconSize(50))
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(avatarImageView.size)
            make.top.equalTo(AdaptIconSize(19))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptIconSize(10))
            make.left.equalToSuperview().offset(AdaptIconSize(15))
            make.right.equalToSuperview().offset(AdaptIconSize(-15))
            make.height.equalTo(AdaptIconSize(22))
        }
        listenLabel.sizeToFit()
        listenLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptIconSize(24))
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptIconSize(24))
            make.size.equalTo(listenLabel.size)
        }
        reviewLabel.sizeToFit()
        reviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel)
            make.top.equalTo(listenLabel.snp.bottom).offset(AdaptIconSize(9))
            make.size.equalTo(reviewLabel.size)
        }
        listenResultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel.snp.right).offset(AdaptIconSize(14))
            make.centerY.equalTo(listenLabel)
            make.right.equalToSuperview().offset(AdaptIconSize(-15))
            make.height.equalTo(AdaptIconSize(18))
        }
        reviewResultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(AdaptIconSize(14))
            make.centerY.equalTo(reviewLabel)
            make.right.equalToSuperview().offset(AdaptIconSize(-15))
            make.height.equalTo(AdaptIconSize(18))
        }
        listenStarView.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel.snp.right).offset(AdaptIconSize(10))
            make.size.equalTo(CGSize(width: AdaptIconSize(63), height: AdaptIconSize(21)))
            make.centerY.equalTo(listenLabel)
        }
        reviewStarView.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(AdaptIconSize(10))
            make.size.equalTo(CGSize(width: AdaptIconSize(63), height: AdaptIconSize(21)))
            make.centerY.equalTo(reviewLabel)
        }
    }

    private func bindProperty() {
        self.listenStarView.isHidden = true
        self.reviewStarView.isHidden = true
    }

    func setData(_ model: YXStudentModel) {
        guard let userInfo = model.userInfo else {
            return
        }
        self.nameLabel.text = userInfo.name
        let defaultImage = UIImage(named: "challengeAvatar")
        if let urlStr = userInfo.avatarUrl, urlStr.isNotEmpty {
            YXKVOImageView().showImage(with: urlStr, placeholder: defaultImage, progress: nil) { [weak self] (image: UIImage?, error: NSError?, url: NSURL?) in
                guard let self = self else { return }
                self.avatarImageView.image = image?.corner(radius: AdaptIconSize(25), with: self.avatarImageView.size)
            }
        } else {
            self.avatarImageView.image = defaultImage
        }
        guard let learnInfo = model.learnInfo else {
            return
        }
        if learnInfo.listenState == .finish {
            self.listenStarView.isHidden    = false
            self.listenResultLabel.isHidden = true
            self.listenStarView.showStudentResultView(starNum: learnInfo.listenStar)
        } else {
            self.listenStarView.isHidden    = true
            self.listenResultLabel.isHidden = false
        }
        if learnInfo.reviewState == .finish {
            self.reviewStarView.isHidden    = false
            self.reviewResultLabel.isHidden = true
            self.reviewStarView.showStudentResultView(starNum: learnInfo.reviewStar)
        } else {
            self.reviewStarView.isHidden    = true
            self.reviewResultLabel.isHidden = false
        }
    }
}
