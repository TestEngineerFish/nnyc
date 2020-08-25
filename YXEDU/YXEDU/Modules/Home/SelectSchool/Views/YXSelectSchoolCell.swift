//
//  YXSelectSchoolCell.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectSchoolCell: UITableViewCell {
    var nameLable: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "exercise_answer_right")
        imageView.isHidden = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(nameLable)
        self.addSubview(iconImageView)
        nameLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.height.equalTo(0)
            make.right.equalTo(iconImageView.snp.left).offset(AdaptSize(-15))
        }
        iconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(15), height: AdaptSize(15)))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
    }

    func setData(school model: YXLocalModel) {
        self.nameLable.text = model.name
        let nameLabelHeight = model.name.textHeight(font: nameLable.font, width: screenWidth - AdaptSize(66))
        self.nameLable.snp.updateConstraints { (make) in
            make.height.equalTo(nameLabelHeight)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.nameLable.textColor    = selected ? UIColor.black1 : UIColor.gray3
        self.iconImageView.isHidden = !selected
    }
}
