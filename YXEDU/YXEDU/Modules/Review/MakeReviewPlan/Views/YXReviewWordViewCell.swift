//
//  YXReviewUnitListCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewWordViewCell: UITableViewCell {

    var selectBarBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(22), left: AdaptSize(22), bottom: AdaptSize(22), right: AdaptSize(18))
        return button
    }()

    var barImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.hex(0xEEEEEE)
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pfSCSemiboldFont(withSize: AdaptSize(15))
        label.textColor = UIColor.black1
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        label.textColor = UIColor.black3
        return label
    }()

    var statusButton: YXButton = {
        let button = YXButton()
        button.setTitle("未学", for: .normal)
        button.setTitleColor(UIColor.hex(0xCDB387), for: .normal)
        button.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(10))
        button.layer.borderWidth = AdaptSize(1)
        button.layer.borderColor = UIColor.hex(0xCDB387).cgColor
        button.isEnabled = false
        button.isHidden  = true
        return button
    }()

    var model: YXReviewWordModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ model: YXReviewWordModel) {
        self.model = model
        if model.isSelected {
            self.barImageView.image = UIImage(named: "word_selected")
        } else {
            self.barImageView.image = nil
        }
        self.titleLabel.text       = model.word
        self.statusButton.isHidden = model.isLearn
        self.descriptionLabel.text = {
            var text = ""
            for p in model.paraphrase {
                text.append(p.key)
                text.append(p.value)
            }
            return text
        }()
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model = self.model else {
            return
        }
        let titleWidth = model.word.textWidth(font: self.titleLabel.font, height: AdaptSize(21))
        self.titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(titleWidth)
        }
    }

    private func setSubviews() {
        self.contentView.addSubview(selectBarBtn)
        selectBarBtn.addSubview(barImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(statusButton)

        self.selectBarBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(56))
        }
        let barSize = CGSize(width: AdaptSize(16), height: AdaptSize(16))
        self.barImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(barSize)
        }
        self.barImageView.layer.cornerRadius = barSize.height / 2
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.selectBarBtn.snp.right)
            make.top.equalToSuperview().offset(AdaptSize(9))
            make.height.equalTo(AdaptSize(21))
            make.width.equalTo(CGFloat.zero)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.equalTo(self.selectBarBtn.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(AdaptSize(20))
        }
        self.statusButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right).offset(AdaptSize(13))
            make.size.equalTo(CGSize(width: AdaptSize(41), height: AdaptSize(14)))
            make.centerY.equalTo(self.titleLabel)
            make.right.greaterThanOrEqualToSuperview().priorityHigh()
        }
    }
}
