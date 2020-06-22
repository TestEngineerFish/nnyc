//
//  YXSearchSchoolListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXSearchSchoolListView: YXView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.hex(0x999999), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(15))
        return button
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "选择学校"
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
    var searchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray5
        return view
    }()
    var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchSchool")
        return imageView
    }()
    var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder     = "可输入关键字搜索"
        return textField
    }()
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
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
        self.backgroundColor      = .white
        self.textField.delegate   = self
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.searchBackgroundView.layer.cornerRadius  = AdaptSize(6)
        self.searchBackgroundView.layer.masksToBounds = true
        self.tableView.register(YXSelectSchoolCell.classForCoder(), forCellReuseIdentifier: "kYXSelectSchoolCell")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
        self.addSubview(downButton)
        self.addSubview(lineView)
        self.addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(searchImageView)
        searchBackgroundView.addSubview(textField)
        self.addSubview(tableView)
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(13))
            make.centerX.equalToSuperview()
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
        searchBackgroundView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalTo(lineView).offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(40))
        }
        searchImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(searchImageView.snp.right).offset(AdaptSize(10))
            make.centerY.equalToSuperview()
            make.height.equalTo(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
        }
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(searchBackgroundView.snp.bottom)
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXSelectSchoolCell", for: indexPath) as? YXSelectSchoolCell else {
            return UITableViewCell()
        }
        cell.setData(school: "学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称学校名称")
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
