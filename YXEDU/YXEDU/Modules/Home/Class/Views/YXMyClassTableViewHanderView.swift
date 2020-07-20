//
//  YXMyClassTableViewHanderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassTableViewHanderView: YXView {
    var myClassLabel: UILabel = {
        let label = UILabel()
        label.text          = "我的班级"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        return label
    }()

    var joinButton: YXButton = {
        let button = YXButton()
        button.layer.borderWidth = AdaptSize(0.5)
        button.layer.borderColor = UIColor.black4.cgColor
        button.setImage(UIImage(named: "review_add_icon"), for: .normal)
        button.setTitle("加入班级", for: .normal)
        button.setTitleColor(UIColor.gray3, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(13))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(myClassLabel)
        self.addSubview(joinButton)
        myClassLabel.sizeToFit()
        myClassLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(AdaptSize(3))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(myClassLabel.size)
        }
        joinButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(myClassLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(CGSize(width: AdaptSize(88), height: AdaptSize(28)))
        }
        joinButton.cornerRadius = AdaptSize(14)
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white
        self.joinButton.addTarget(self, action: #selector(joinClass), for: .touchUpInside)
    }

    // TODO: ==== Event ====
    @objc private func joinClass() {
        let alertView = YXAlertView(type: .inputable, placeholder: "输入班级号或作业提取码")
        alertView.titleLabel.text = "请输入班级号或作业提取码"
        alertView.shouldOnlyShowOneButton = false
        alertView.shouldClose = false
        alertView.doneClosure = {(classNumber: String?) in
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                alertView.removeFromSuperview()
            }
            YXLog("班级号：\(classNumber ?? "")")
        }
        alertView.clearButton.isHidden    = true
        alertView.textCountLabel.isHidden = true
        alertView.textMaxLabel.isHidden   = true
        alertView.alertHeight.constant    = 222
        alertView.show()
    }
}
