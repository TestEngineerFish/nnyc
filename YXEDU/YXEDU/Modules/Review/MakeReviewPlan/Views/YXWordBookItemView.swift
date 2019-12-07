//
//  YXWordBookItemView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordBookItemView: UIView {
    var bookImageView = UIImageView()
    var signImageView = UIImageView()
    var numberlabel: UILabel = {
        let label = UILabel()
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptSize(10))
        label.textColor = UIColor.white
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
        self.addSubview(numberlabel)
        self.addSubview(signImageView)
        self.addSubview(titleLabel)

        self.bookImageView.image = UIImage(named: "book_unselect")
        self.signImageView.image = UIImage(named: "unit_arrow")
        self.numberlabel.text    = "\(self.model.wordsNumber)词"
        self.titleLabel.text     = self.model.name
        self.titleLabel.contentMode    = .top
        self.titleLabel.numberOfLines  = 0
        self.numberlabel.numberOfLines = 0
        self.titleLabel.textAlignment  = .center
        self.numberlabel.textAlignment = .center

        self.bookImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(6))
            make.size.equalTo(CGSize(width: AdaptSize(43), height: AdaptSize(49)))
        }
        self.numberlabel.snp.makeConstraints { (make) in
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
