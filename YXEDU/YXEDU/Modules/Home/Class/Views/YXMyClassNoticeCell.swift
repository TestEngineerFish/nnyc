//
//  YXMyClassNoticeCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassNoticeCell: UITableViewCell {

    var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.hex(0xBBBBBB)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()
    var customContentView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(12)
        view.layer.setDefaultShadow()
        return view
    }()
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
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(timeLabel)
        self.addSubview(customContentView)
        customContentView.addSubview(redDotView)
        customContentView.addSubview(contentLabel)
        customContentView.addSubview(descriptionLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(18))
            make.top.equalToSuperview().offset(AdaptSize(10))
        }
        customContentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(timeLabel.snp.bottom).offset(AdaptSize(10))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(contentLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(18))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        redDotView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-5))
            make.size.equalTo(redDotView.size)
        }
    }

    func setData(model: YXMyClassNoticeModel) {
        self.redDotView.isHidden   = model.isRead
        self.contentLabel.text     = model.content
        self.timeLabel.text        = model.timeStr
        self.descriptionLabel.text = model.teacherName + "  |  " + model.className
    }
}
