//
//  YXReviewSelectedWordCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewSelectedWordCell: UITableViewCell {

    var removeButton: YXButton = {
        let button = YXButton()
        button.setImage(UIImage(named: "word_delete"), for: .normal)
        return button
    }()

    var wordLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.pfSCMediumFont(withSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()

    var paraphraseLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black3
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(12))
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        self.contentView.addSubview(removeButton)
        self.contentView.addSubview(wordLabel)
        self.contentView.addSubview(paraphraseLabel)

        removeButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(8), height: AdaptSize(8)))
        }

        wordLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(removeButton.snp.right).offset(AdaptSize(6))
            make.right.equalTo(paraphraseLabel.snp.left).offset(AdaptSize(-12))
            make.height.equalToSuperview()
        }

        paraphraseLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.greaterThanOrEqualToSuperview().offset(AdaptSize(-15)).priorityHigh()
        }
    }


}
