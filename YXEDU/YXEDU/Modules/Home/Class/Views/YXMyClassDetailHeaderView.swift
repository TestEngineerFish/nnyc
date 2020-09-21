//
//  YXMyClassDetailHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassDetailHeaderView: YXView {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    var numberTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "班号："
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(13))
        label.textAlignment = .center
        return label
    }()

    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor     = .orange1
        label.font          = .mediumFont(ofSize: AdaptIconSize(13))
        label.textAlignment = .left
        return label
    }()

    var campusLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()

    var copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("复制", for: .normal)
        button.backgroundColor = .orange1
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(11))
        button.titleLabel?.backgroundColor = UIColor.orange1
        return button
    }()

    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xF4F4F4)
        return view
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment  = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(nameLabel)
        self.addSubview(numberTitleLabel)
        self.addSubview(numberLabel)
        self.addSubview(campusLabel)
        self.addSubview(copyButton)
        self.addSubview(lineView)
        self.addSubview(subtitleLabel)
        self.nameLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalToSuperview().offset(AdaptSize(17))
        }
        self.numberTitleLabel.sizeToFit()
        self.numberTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(AdaptSize(18))
            make.width.equalTo(numberTitleLabel.width)
        }
        self.numberLabel.sizeToFit()
        self.numberLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(numberTitleLabel.snp.right)
            make.centerY.equalTo(numberTitleLabel)
            make.height.equalTo(AdaptSize(18))
            make.width.equalTo(numberLabel.width)
        }
        self.copyButton.sizeToFit()
        self.copyButton.snp.remakeConstraints { (make) in
            make.left.equalTo(numberLabel.snp.right).offset(AdaptSize(8))
            make.centerY.equalTo(numberTitleLabel)
            make.width.equalTo(AdaptSize(28))
            make.height.equalTo(AdaptSize(15))
        }
        self.campusLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(numberTitleLabel.snp.bottom).offset(AdaptSize(5))
            make.height.equalTo(AdaptSize(18))
        }
        self.lineView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(campusLabel.snp.bottom).offset(AdaptSize(20))
            make.height.equalTo(AdaptSize(10))
        }
        self.subtitleLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(lineView.snp.bottom).offset(AdaptSize(20))
            make.height.equalTo(AdaptSize(21))
            make.bottom.equalToSuperview().offset(AdaptSize(-5))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white
        self.copyButton.layer.cornerRadius  = AdaptSize(2)
        self.copyButton.layer.masksToBounds = true
        self.copyButton.addTarget(self, action: #selector(copyNumber), for: .touchUpInside)
    }

    func setData(class model: YXMyClassDetailModel?) {
        guard let _model = model else {
            return
        }
        self.numberLabel.text = _model.code
        let subtitleLabelAttriText = NSMutableAttributedString(string: "班级成员 （\(_model.studentCount)人）", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black3, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptFontSize(14))])
        subtitleLabelAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptFontSize(15))], range: NSRange(location: 0, length: 4))
        self.subtitleLabel.attributedText = subtitleLabelAttriText
        self.nameLabel.text   = _model.className
        self.campusLabel.text = _model.schoolName
        self.createSubviews()
    }

    @objc private func copyNumber() {
        UIPasteboard.general.string = self.numberLabel.text
        YXUtils.showHUD(nil, title: "班号已复制")
    }

}
