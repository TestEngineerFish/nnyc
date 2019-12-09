//
//  YXReviewBookItem.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewBookItem: UIView {
    var bookImageView = UIImageView()
    var signImageView = UIImageView()
    var infolabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(10))
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(10))
        label.textColor = UIColor.black2
        return label
    }()

    var model: YXReviewWordBookItemModel


    init(_ model: YXReviewWordBookItemModel, frame: CGRect) {
        self.model = model
        super.init(frame: frame)
        self.setSubviews()
    }

    private func setSubviews() {
        self.addSubview(bookImageView)
        self.addSubview(infolabel)
        self.addSubview(signImageView)
        self.addSubview(titleLabel)

        let versionName = model.versionName.isEmpty ? "" : model.versionName + "\n"
        self.bookImageView.image = UIImage(named: "book_unselect")
        self.signImageView.image = UIImage(named: "unit_arrow")
        self.infolabel.text      = String(format: "%@%d词", versionName, model.wordsNumber)
        self.titleLabel.text     = self.model.name
        self.titleLabel.contentMode    = .top
        self.titleLabel.numberOfLines  = 0
        self.infolabel.numberOfLines   = 0
        self.titleLabel.textAlignment  = .center
        self.infolabel.textAlignment   = .center

        self.bookImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(43), height: AdaptSize(49)))
        }
        self.infolabel.snp.makeConstraints { (make) in
            make.center.width.height.equalTo(self.bookImageView)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bookImageView.snp.bottom).offset(AdaptSize(4))
            make.left.right.equalToSuperview()
        }
        self.signImageView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self.bookImageView)
            make.size.equalTo(CGSize(width: AdaptSize(18.07), height: AdaptSize(19.5)))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let titleHeight: CGFloat = self.titleLabel.text?.textHeight(font: self.titleLabel.font, width: self.width) ?? CGFloat.zero
        self.titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
