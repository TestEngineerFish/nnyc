//
//  YXMyClassNoticeCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassNoticeCell: UITableViewCell {
    var redDotView = YXRedDotView()
    var contentLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(model: YXMyClassNoticeModel) {
        self.redDotView.isHidden = !model.isNew
        self.contentLabel.text   = model.content
        self.timeLabel.text      = model.time
        self.createSubviews()
    }

    private func createSubviews() {
        self.addSubview(redDotView)
        self.addSubview(contentLabel)
        self.addSubview(timeLabel)
        self.separatorInset = UIEdgeInsets(top: 0, left: AdaptSize(20), bottom: 0, right: AdaptSize(20))
        if redDotView.isHidden {
            let contentH = self.contentLabel.text?.textHeight(font: contentLabel.font, width: screenWidth - AdaptSize(40)) ?? 0
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(20))
                make.left.equalToSuperview().offset(AdaptSize(20))
                make.right.equalToSuperview().offset(AdaptSize(-20))
                make.height.equalTo(contentH)
            }
        } else {
            let contentH = self.contentLabel.text?.textHeight(font: contentLabel.font, width: screenWidth - AdaptSize(51)) ?? 0
            redDotView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(20))
                make.size.equalTo(CGSize(width: AdaptSize(6), height: AdaptSize(6)))
                make.top.equalToSuperview().offset(AdaptSize(30))
            }
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(20))
                make.left.equalTo(redDotView.snp.right).offset(AdaptSize(5))
                make.right.equalToSuperview().offset(AdaptSize(-20))
                make.height.equalTo(contentH)
            }
        }
        timeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize(10))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.height.equalTo(AdaptSize(18))
            make.bottom.equalToSuperview().offset(AdaptSize(-20))
        }
    }
}
