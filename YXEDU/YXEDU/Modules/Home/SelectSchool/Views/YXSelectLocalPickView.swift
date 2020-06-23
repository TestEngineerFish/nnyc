//
//  YXSelectLocalPickView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSelectLocalPickView: YXView {
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.hex(0x999999), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return button
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "选择地址"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(16))
        label.textAlignment = .center
        return label
    }()
    var downButton: UIButton = {
        let button = UIButton()
        button.setTitle("确认", for: .normal)
        button.setTitleColor(UIColor.blue2, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return button
    }()
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4
        return view
    }()
    var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
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
        self.backgroundColor     = .white
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
        self.addSubview(downButton)
        self.addSubview(lineView)
        self.addSubview(pickerView)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(13))
            make.size.equalTo(titleLabel.size)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(30)))
        }
        downButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(30)))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(0.5))
            make.top.equalToSuperview().offset(AdaptSize(48))
        }
        pickerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
    }

}
