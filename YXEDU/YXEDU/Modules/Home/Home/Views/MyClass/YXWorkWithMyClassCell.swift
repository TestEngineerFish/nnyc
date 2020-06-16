//
//  YXWorkWithMyClassCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWorkWithMyClassCell: UITableViewCell {

    var wrapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()

    var desciptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    var progressLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var statusImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    var actionButton: YXButton = {
        let button = YXButton(.border, frame: .zero)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(14))
        return button
    }()

    let progressView = YXReviewProgressView(type: .iKnow)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(wrapView)
        wrapView.addSubview(statusImage)
        wrapView.addSubview(nameLabel)
        wrapView.addSubview(desciptionLabel)
        wrapView.addSubview(progressLabel)
        wrapView.addSubview(progressView)
        wrapView.addSubview(actionButton)
        wrapView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalToSuperview().offset(AdaptSize(7.5))
            make.bottom.equalToSuperview().offset(AdaptSize(-7.5))
        }
        statusImage.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(46), height: AdaptSize(46)))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(0)
        }
        desciptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(5))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        progressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.width.equalTo(0)
            make.height.equalTo(AdaptSize(17))
        }
        progressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(progressLabel)
            make.left.equalTo(progressLabel.snp.right).offset(AdaptSize(5))
            make.size.equalTo(CGSize(width: AdaptSize(113), height: AdaptSize(4)))
        }
    }

    private func bindProperty() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        self.wrapView.layer.setDefaultShadow(cornerRadius: 12, shadowRadius: 10)
        self.actionButton.addTarget(self, action: #selector(actionEvent), for: .touchUpInside)
    }

    func setData() {
        self.nameLabel.text        = "6月4日单词练习作业"
        self.progressLabel.text    = "完成50%"
        self.desciptionLabel.text  = "3班 ｜ 3天后截止"
        self.progressView.progress = 0.5
        nameLabel.sizeToFit()
        nameLabel.snp.updateConstraints { (make) in
            make.height.equalTo(nameLabel.height)
        }
        progressLabel.sizeToFit()
        progressLabel.snp.updateConstraints { (make) in
            make.width.equalTo(progressLabel.width)
        }
    }

    // MARK: ==== Event ====
    @objc private func actionEvent() {
        YXLog("查看详情")
    }

}
