//
//  YXSelectSchoolContentView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectSchoolContentView: YXView {

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chooseGuideBook")
        return imageView
    }()
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.masksToBounds = true
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择您孩子的就读学校"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(17))
        label.textAlignment = .left
        return label
    }()
    var localLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择学校地址"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    var localBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var schoolLabel: UILabel = {
        let label = UILabel()
        label.text          = "请选择学校名称"
        label.textColor     = UIColor.black6
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    var schoolBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var submitButton: YXButton = {
        let button = YXButton(.theme, frame: .zero)
        button.setTitle("提交", for: .normal)
        button.setStatus(.disable)
        return button
    }()
    var bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selectSchoolBottomImage")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.hex(0xFFF7EB)
        self.contentView.layer.cornerRadius = AdaptSize(16)
        self.contentView.layer.borderColor  = UIColor.orange1.cgColor
        self.contentView.layer.borderWidth  = AdaptSize(5)
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(iconImageView)
        self.addSubview(contentView)
        self.addSubview(submitButton)
        self.addSubview(bottomImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(localLabel)
        contentView.addSubview(schoolLabel)
        contentView.addSubview(localBottomLineView)
        contentView.addSubview(schoolBottomLineView)
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(AdaptSize(223))
            make.centerY.equalToSuperview().offset(AdaptSize(-60))
            make.left.equalToSuperview().offset(AdaptSize(23))
            make.right.equalToSuperview().offset(AdaptSize(-23))
        }
        iconImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.top)
            make.size.equalTo(CGSize(width: AdaptSize(82), height: AdaptSize(67)))
            make.right.equalTo(contentView.snp.right).offset(AdaptSize(-15))
        }
        submitButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(273), height: AdaptSize(42)))
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(AdaptSize(30))
        }
        bottomImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(AdaptSize(107))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.top.equalToSuperview().offset(AdaptSize(23))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.height.equalTo(AdaptSize(24))
        }
        localLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(AdaptSize(20))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(30))
        }
        localBottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(AdaptSize(0.5))
            make.top.equalTo(localLabel.snp.bottom).offset(AdaptSize(10))
        }
        schoolLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(AdaptSize(20))
            make.top.equalTo(localBottomLineView.snp.bottom).offset(AdaptSize(20))
        }
        schoolBottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(schoolLabel)
            make.height.equalTo(AdaptSize(0.5))
            make.top.equalTo(schoolLabel.snp.bottom).offset(AdaptSize(10))
        }
    }

    // MARK: ==== Event ====
    func setSelectLocal(local: String?) {
        self.localLabel.text      = local
        self.localLabel.textColor = UIColor.black1
    }

    func setSelectSchool(school: String?) {
        if school == nil {
            self.schoolLabel.text      = "请选择学校名称"
            self.schoolLabel.textColor = UIColor.black6
            self.submitButton.setStatus(.disable)
        } else {
            self.schoolLabel.text       = school
            self.schoolLabel.textColor  = UIColor.black1
            self.submitButton.setStatus(.normal)
        }
    }
}
