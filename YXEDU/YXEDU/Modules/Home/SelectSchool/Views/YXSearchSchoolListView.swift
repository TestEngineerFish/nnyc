//
//  YXSearchSchoolListView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

protocol YXSearchSchoolDelegate: NSObjectProtocol {
    func selectSchool(school model: YXLocalModel?)
}

class YXSearchSchoolListView: YXView, UITableViewDelegate, UITableViewDataSource {

    var schoolModelList = [YXLocalModel]()
    var selectLocalModel: YXLocalModel?
    var willSchoolModel: YXLocalModel?
    var selectSchoolModel: YXLocalModel? {
        didSet {
            self.willSchoolModel = nil
        }
    }
    weak var delegate: YXSearchSchoolDelegate?

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.opacity   = 0.0
        return view
    }()
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

    init() {
        let _frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight * 0.92)
        super.init(frame: _frame)
        self.bindProperty()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.backgroundColor      = .white
        self.searchBackgroundView.layer.cornerRadius  = AdaptSize(6)
        self.searchBackgroundView.layer.masksToBounds = true
        self.tableView.register(YXSelectSchoolCell.classForCoder(), forCellReuseIdentifier: "kYXSelectSchoolCell")
        self.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.downButton.addTarget(self, action: #selector(downSelectSchool), for: .touchUpInside)
        self.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(5))
        self.textField.addTarget(self, action: #selector(seachSchool(_:)), for: .editingChanged)
    }

    override func createSubviews() {
        super.createSubviews()
        kWindow.addSubview(self.backgroundView)
        kWindow.addSubview(self)
        self.addSubview(cancelButton)
        self.addSubview(titleLabel)
        self.addSubview(downButton)
        self.addSubview(lineView)
        self.addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(searchImageView)
        searchBackgroundView.addSubview(textField)
        self.addSubview(tableView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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

    // MARK: ==== Event ====
    func show(selectLocal model: YXLocalModel) {
        self.selectLocalModel = model
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.layer.opacity = 1.0
            self.transform = CGAffineTransform(translationX: 0, y: -self.height)
        }) { (finished) in
            if finished {
                self.textField.becomeFirstResponder()
            }
        }
    }

    @objc func hide() {
        self.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.layer.opacity = 0.0
            self.transform = .identity
        }) { (finished) in
            if finished {
                self.textField.text = nil
                self.schoolModelList.removeAll()
                self.tableView.reloadData()
            }
        }
    }

    @objc private func downSelectSchool() {
        self.selectSchoolModel = self.willSchoolModel
        self.hide()
        self.delegate?.selectSchool(school: self.selectSchoolModel)
    }

    @objc private func seachSchool(_ textField: UITextField) {
        guard var school = textField.text else {
            return
        }
        self.schoolModelList.removeAll()
        self.tableView.reloadData()
        school = school.trimed
        if school != "" {
            self.searchSchool(name: school)
        }
    }

    // MARK: ==== Request ====
    private func searchSchool(name: String) {
        guard let model = self.selectLocalModel else {
            return
        }
        let request = YXSelectSchoolRequestManager.searchSchool(name: name, areaId: model.id)
        YYNetworkService.default.request(YYStructDataArrayResponse<YXLocalModel>.self, request: request, success: { (response) in
            guard let modelList = response.dataArray else {
                return
            }
            self.schoolModelList = modelList
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }


    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXSelectSchoolCell", for: indexPath) as? YXSelectSchoolCell else {
            return UITableViewCell()
        }
        let schoolModel = self.schoolModelList[indexPath.row]
        cell.setData(school: schoolModel)
        if .some(schoolModel.id) == self.selectSchoolModel?.id {
            cell.setSelected(true, animated: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.willSchoolModel = self.schoolModelList[indexPath.row]
    }
}
