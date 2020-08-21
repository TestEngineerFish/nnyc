//
//  YXHomeworkWordListHeaderCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXHomeworkWordListHeaderCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        return label
    }()

    init(bookName: String) {
        self.titleLabel.text = bookName
        super.init(style: .default, reuseIdentifier: nil)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview().offset(AdaptFontSize(-15))
        }
    }

    private func bindProperty() {
        self.separatorInset = UIEdgeInsets(top: 0, left: screenWidth, bottom: 0, right: 0)
        self.selectionStyle = .none
    }
}
