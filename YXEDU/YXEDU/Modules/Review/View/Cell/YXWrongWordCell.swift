//
//  YXWrongWordCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWrongWordCell: UITableViewCell {
    var wordLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        return label
    }()

    var meaningLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(wordLabel)
        self.addSubview(meaningLabel)

        wordLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(AdaptSize(132))
        }
        meaningLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-28))
            make.width.equalTo(AdaptSize(100))
        }
    }

    func bindData(_ word: String, meaning: String) {
        self.wordLabel.text    = word
        self.meaningLabel.text = meaning
    }

}
