//
//  YXReviewUnitListCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewWordListView: UITableViewCell {

    var selectView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        return view
    }()

    var selectBarBtn: YXButton = {
        let button = YXButton()
        button.backgroundColor = UIColor.hex(0xEEEEEE)
        return button
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
        self.selectBarBtn.backgroundColor = model.isSelected ? UIColor.orange1 : UIColor.hex(0xEEEEEE)
        self.titleLabel.text       = model.word
        self.descriptionLabel.text = String(format: "%@%@", model.property, model.paraphrase)
        self.statusButton.isHidden = model.isLearn
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
        self.contentView.addSubview(selectView)
        self.selectView.addSubview(selectBarBtn)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(statusButton)

        self.selectView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(56))
        }
        self.selectBarBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(16), height: AdaptSize(16)))
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.selectView.snp.right)
            make.top.equalToSuperview().offset(AdaptSize(9))
            make.height.equalTo(AdaptSize(21))
            make.width.equalTo(CGFloat.zero)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.equalTo(self.selectView.snp.right)
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
