//
//  YXMyClassTableViewClassCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassTableViewClassCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        return label
    }()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right_gray")
        return imageView
    }()
    let redDot = YXRedDotView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(model: YXMyClassModel) {
        self.nameLabel.text  = model.name
        self.redDot.isHidden = !model.isNew
    }

    private func bindProperty() {
        self.selectionStyle = .none
    }

    private func createSubviews() {
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(15), bottom: 0, right: AdaptSize(-15))
        self.addSubview(nameLabel)
        self.addSubview(redDot)
        self.addSubview(arrowImageView)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(21))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalTo(redDot.snp.left).offset(AdaptSize(-15))
        }
        redDot.snp.makeConstraints { (make) in
            make.size.equalTo(redDot.size)
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(AdaptSize(-5))
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(8), height: AdaptSize(15)))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
    }
}
