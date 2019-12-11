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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubviews()
    }

    func bindData(_ bookModel: YXReviewWordBookItemModel) {
        self.bookImageView.image = bookModel.isSelected ? UIImage(named: "book_selected") : UIImage(named: "book_unselect")
        let versionName          = bookModel.versionName.isEmpty ? "" : bookModel.versionName + "\n"
        self.infolabel.text      = String(format: "%@%d词", versionName, bookModel.wordsNumber)
        self.titleLabel.text     = bookModel.name
    }

    private func setSubviews() {
        self.addSubview(bookImageView)
        self.addSubview(infolabel)
        self.addSubview(titleLabel)

        self.infolabel.numberOfLines   = 0
        self.titleLabel.textAlignment  = .center
        self.infolabel.textAlignment   = .center

        self.bookImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(52)))
        }
        self.infolabel.snp.makeConstraints { (make) in
            make.center.width.height.equalTo(self.bookImageView)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bookImageView.snp.bottom).offset(AdaptSize(4))
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(15))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
