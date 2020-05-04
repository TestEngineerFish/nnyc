//
//  YXFeedbackCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXFeedbackCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black1
        label.font      = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.hex(0x666666)
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.numberOfLines = 0
        return label
    }()
    
    var dotView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.hex(0xFF532B)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = AdaptSize(2.5)
        view.isHidden            = true
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
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
        self.addSubview(titleLabel)
        self.addSubview(dotView)
        self.addSubview(contentLabel)
        self.addSubview(lineView)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.width.equalTo(0)
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(21))
        }
        dotView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(6))
            make.centerY.equalTo(self.titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(5), height: AdaptSize(5)))
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(10))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(18))
            make.right.equalToSuperview().offset(AdaptSize(-18))
            make.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(0.5))
        }
    }
    
    func setData(_ model: YXFeedbackReplyModel) {
        self.titleLabel.text   = (model.dateStr ?? "") + " 用户反馈"
        self.dotView.isHidden  = model.isRead
        self.contentLabel.text = model.content
        let titleW = self.titleLabel.text?.textWidth(font: self.titleLabel.font, height: AdaptSize(21)) ?? 0
        self.titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(titleW)
        }
    }
}
