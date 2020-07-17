//
//  YXMyWorkTableViewHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyWorkTableViewHeaderView: YXView, UITableViewDelegate, UITableViewDataSource {

    var classList = [YXMyClassModel]()

    var tableViewWarpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        return tableView
    }()

    var workTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "班级作业"
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        label.textAlignment = .left
        return label
    }()

    var joinButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = AdaptSize(0.5)
        button.layer.borderColor = UIColor.black4.cgColor
        button.setImage(UIImage(named: "review_add_icon"), for: .normal)
        button.backgroundColor = .white
        button.setTitle("提取作业", for: .normal)
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
//        self.addSubview(tableViewWarpView)
//        tableViewWarpView.addSubview(tableView)
        self.addSubview(workTitleLabel)
        self.addSubview(joinButton)
//        tableViewWarpView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(AdaptSize(22))
//            make.right.equalToSuperview().offset(AdaptSize(-22))
//            make.top.equalToSuperview().offset(AdaptSize(4))
//            make.bottom.equalTo(workTitleLabel.snp.top).offset(AdaptSize(-25))
//        }
//        tableView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        workTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(20))
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.bottom.equalToSuperview().offset(AdaptSize(-7.5))
        }
        joinButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(workTitleLabel)
            make.right.equalToSuperview().offset(AdaptSize(-20))
            make.size.equalTo(CGSize(width: AdaptSize(88), height: AdaptSize(28)))
        }
        joinButton.layer.cornerRadius = AdaptSize(14)
//        self.tableView.layer.setDefaultShadow(cornerRadius: AdaptSize(12), shadowRadius: 10)
//        self.tableView.layer.masksToBounds = true
//        self.tableViewWarpView.layer.setDefaultShadow(cornerRadius: AdaptSize(12), shadowRadius: 10)
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor           = .clear
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
        self.tableView.register(YXMyClassTableViewClassCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassTableViewClassCell")
        self.joinButton.addTarget(self, action: #selector(joinClass), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    func setDate(class modelList: [YXMyClassModel]) {
        self.classList = modelList
        self.tableView.reloadData()
    }

    @objc private func joinClass() {
        let alertView = YXAlertView(type: .inputable, placeholder: "输入班级号或作业提取码")
        alertView.titleLabel.text = "请输入班级号或作业提取码"
        alertView.shouldOnlyShowOneButton = false
        alertView.shouldClose = false
        alertView.doneClosure = {(classNumber: String?) in
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                if result != nil {
                    alertView.removeFromSuperview()
                }
            }
            YXLog("班级号：\(classNumber ?? "")")
        }
        alertView.clearButton.isHidden    = true
        alertView.textCountLabel.isHidden = true
        alertView.textMaxLabel.isHidden   = true
        alertView.alertHeight.constant    = 222
        alertView.show()
    }

    // MARK: ==== UITableViewDeletegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassTableViewHanderView()
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassTableViewClassCell") as? YXMyClassTableViewClassCell else {
            return UITableViewCell()
        }
        cell.setData(model: classList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(42)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(50)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXMyClassDetailViewController()
        vc.classId = self.classList[indexPath.row].id
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
    }
}
