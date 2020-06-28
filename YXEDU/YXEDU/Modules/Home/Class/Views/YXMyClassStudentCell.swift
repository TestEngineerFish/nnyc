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
        imageView.image = UIImage(named: "userPlaceHolder")
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
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
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
        self.addSubview(lineView)
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
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(78))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(0.5))
            make.bottom.equalToSuperview()
        }
        avatarImageView.layer.cornerRadius  = AdaptSize(24)
        avatarImageView.layer.masksToBounds = true
    }

    private func bindProperty() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(78), bottom: 0, right: AdaptSize(15))
    }

    func setData(student model: YXMyClassStudentInfoModel) {
        if !model.avatarUrl.isEmpty {
            self.avatarImageView.showImage(with: model.avatarUrl, placeholder: UIImage(named: "userPlaceHolder"), progress: nil, completion: nil)
        } else {
            self.avatarImageView.image = UIImage(named: "userPlaceHolder")
        }
        self.nameLabel.text = model.name
        self.descLabel.text = "本月学习\(model.learnCount)天"
    }
}
