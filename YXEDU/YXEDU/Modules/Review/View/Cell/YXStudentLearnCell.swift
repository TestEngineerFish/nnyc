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
        imageView.image = UIImage(named: "userPlaceHolder")
        imageView.layer.cornerRadius  = AdaptSize(25)
        imageView.layer.masksToBounds = true
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
        label.text          = "学习"
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
            make.left.top.equalToSuperview().offset(AdaptSize(5))
            make.bottom.right.equalToSuperview().offset(AdaptSize(-5))
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(50), height: AdaptSize(50)))
            make.top.equalTo(AdaptSize(19))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(AdaptSize(10))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(22))
        }
        listenLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(24))
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(24))
            make.size.equalTo(CGSize(width: AdaptSize(27), height: AdaptSize(18)))
        }
        reviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel)
            make.top.equalTo(listenLabel.snp.bottom).offset(AdaptSize(9))
            make.size.equalTo(CGSize(width: AdaptSize(27), height: AdaptSize(18)))
        }
        listenResultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel.snp.right).offset(AdaptSize(14))
            make.centerY.equalTo(listenLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(18))
        }
        reviewResultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(AdaptSize(14))
            make.centerY.equalTo(reviewLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(18))
        }
        listenStarView.snp.makeConstraints { (make) in
            make.left.equalTo(listenLabel.snp.right).offset(AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(63), height: AdaptSize(21)))
            make.centerY.equalTo(listenLabel)
        }
        reviewStarView.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(63), height: AdaptSize(21)))
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
        if let urlStr = userInfo.avatarUrl {
            self.avatarImageView.showImage(with: urlStr)
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
