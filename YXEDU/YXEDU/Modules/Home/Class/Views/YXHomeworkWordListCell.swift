//
//  YXHomeworkWordListCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXHomeworkWordListCell: UITableViewCell {
    var wordLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        return label
    }()

    var meaningLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
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
        self.addSubview(wordLabel)
        self.addSubview(meaningLabel)
        wordLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(24))
        }
        meaningLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(wordLabel)
            make.top.equalTo(wordLabel.snp.bottom).offset(AdaptSize(4))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
    }

    private func bindProperty() {
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(15), bottom: 0, right: AdaptSize(15))
        self.selectionStyle = .none
    }

    func setData(word model: YXWordModel) {
        self.wordLabel.text    = model.word
        self.meaningLabel.text = model.partOfSpeechAndMeaningsStr
    }
}
