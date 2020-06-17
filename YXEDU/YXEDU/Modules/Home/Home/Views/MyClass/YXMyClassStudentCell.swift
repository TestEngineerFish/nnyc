//
//  YXMyClassStudentCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassStudentCell: UITableViewCell {
    var avatarImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        return imageView
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        return label
    }()
    var descLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(descLabel)
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(48), height: AdaptSize(48)))
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.right.equalTo(descLabel.snp.left).offset(AdaptSize(-5))
            make.height.equalTo(AdaptSize(21))
        }
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.width.equalTo(AdaptSize(73))
            make.height.equalTo(AdaptSize(17))
        }
    }

    private func bindProperty() {
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(78), bottom: 0, right: AdaptSize(15))
    }

    func setData() {
        self.avatarImageView.showImage(with: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1601482904,1022427523&fm=26&gp=0.jpg", placeholder: UIImage(named: "userPlaceHolder"), progress: nil, completion: nil)
        self.nameLabel.text = "王大锤"
        self.descLabel.text = "本月学习18天"
    }
}
