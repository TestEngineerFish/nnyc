//
//  YXReviewPlanCollectionViewItem.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXReviewPlanCollectionViewItem: UICollectionViewCell {

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black1
        label.font          = UIFont.pfSCRegularFont(withSize: AdaptSize(20))
        label.textAlignment = .center
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.gray4
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    var listenView: UIView = {
        let view = UIView()
        return view
    }()

    var reviewView: UIView = {
        let view = UIView()
        return view
    }()

    var listenImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "button_height")
        return imageView
    }()

    var reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "button_height")
        return imageView
    }()

    var listenButton: UIButton = {
        let button = UIButton()
        button.setTitle("开始听写", for: .normal)
        button.setTitleColor(UIColor.hex(0x13C600), for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(20))
        button.backgroundColor    = .clear
        button.layer.borderWidth  = AdaptSize(1)
        button.layer.borderColor  = UIColor.hex(0x4FDB40).cgColor
        button.layer.cornerRadius = AdaptSize(21)
        return button
    }()

    var reviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("开始复习", for: .normal)
        button.setTitleColor(UIColor.hex(0xFB7A19), for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(20))
        button.backgroundColor    = .clear
        button.layer.borderWidth  = AdaptSize(1)
        button.layer.borderColor  = UIColor.hex(0xFB7A19).cgColor
        button.layer.cornerRadius = AdaptSize(21)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func createSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(listenView)
        contentView.addSubview(reviewView)
        listenView.addSubview(listenImageView)
        listenView.addSubview(listenButton)
        reviewView.addSubview(reviewImageView)
        reviewView.addSubview(reviewButton)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(28))
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(7))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(AdaptSize(21))
        }
        listenView.size = CGSize(width: AdaptSize(183), height: AdaptSize(167))
        listenView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(21))
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        reviewView.size = CGSize(width: AdaptSize(183), height: AdaptSize(167))
        reviewView.snp.makeConstraints { (make) in
            make.left.equalTo(listenView.snp.right)
            make.bottom.right.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(21))
        }
        listenImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(67), height: AdaptSize(64)))
        }
        listenButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-14))
            make.size.equalTo(CGSize(width: AdaptSize(134), height: AdaptSize(42)))
        }
        reviewImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(4))
            make.size.equalTo(CGSize(width: AdaptSize(67), height: AdaptSize(64)))
        }
        reviewButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-14))
            make.size.equalTo(CGSize(width: AdaptSize(134), height: AdaptSize(42)))
        }
    }

    internal func bindProperty() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.setDefaultShadow()
        self.contentView.layer.cornerRadius = AdaptSize(20)
        self.listenView.clipRectCorner(direction: .bottomLeft, cornerRadius: AdaptSize(20))
        self.reviewView.clipRectCorner(direction: .bottomRight, cornerRadius: AdaptSize(20))
        self.listenView.layer.setGradient(colors: [UIColor.hex(0xFFFFFF), UIColor.hex(0xE8F6EA)], direction: .vertical)
        self.reviewView.layer.setGradient(colors: [UIColor.hex(0xFFFFFF), UIColor.hex(0xFFFAE2)], direction: .vertical)
    }

    func setData(_ model: YXReviewPlanModel) {
        self.titleLabel.text = model.planName
        self.descriptionLabel.text = "单词：\(model.wordCount)"
    }
}
