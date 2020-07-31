//
//  YXUserInfoCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/30.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXUserInfoCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        return label
    }()

    var detailLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .right
        return label
    }()

    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right_gray")
        return imageView
    }()

    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(arrowImageView)
        self.addSubview(avatarImageView)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.height.centerY.equalToSuperview()
            make.right.equalTo(detailLabel.snp.left).offset(AdaptSize(-15)).priorityMedium()
        }
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-15))
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptFontSize(8), height: AdaptSize(12)))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(70), height: AdaptSize(70)))
            make.right.equalTo(detailLabel)
        }
        avatarImageView.layer.cornerRadius  = AdaptSize(35)
        avatarImageView.layer.masksToBounds = true
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(15), bottom: 0, right: AdaptSize(-15))
    }

    private func bindProperty() {
        self.selectionStyle = .none
    }

    func setData(title: String, detail: String, hideAvatar: Bool = true) {
        self.titleLabel.text  = title
        self.detailLabel.text = detail
        self.avatarImageView.isHidden = hideAvatar
        if !hideAvatar {
            if let image = YXUserModel.default.userAvatarImage {
                self.avatarImageView.image = image
            } else if let imageUrlStr = YXUserModel.default.userAvatarPath, imageUrlStr.isNotEmpty {
                self.avatarImageView.sd_setImage(with: URL(string: imageUrlStr), completed: nil)
            } else {
                self.avatarImageView.image = UIImage(named: "challengeAvatar")
            }

        }
    }
}
