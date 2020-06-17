//
//  YXMyWorkTableViewHeaderView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyWorkTableViewHeaderView: YXView, UITableViewDelegate, UITableViewDataSource {

    var classList = [String]()

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
        self.addSubview(tableView)
        self.addSubview(workTitleLabel)
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.top.equalToSuperview().offset(AdaptSize(4))
            make.bottom.equalTo(workTitleLabel.snp.top).offset(AdaptSize(-25))
        }
        workTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview().offset(AdaptSize(-7.5))
        }
        self.tableView.layer.setDefaultShadow(cornerRadius: AdaptSize(12), shadowRadius: 10)
    }

    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }

    func setDate(classList: [String]) {
        self.classList = classList
        self.tableView.reloadData()
    }

    // MARK: ==== UITableViewDeletegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count > 3 ? 3 : self.classList.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassTableViewHanderView()
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text      = classList[indexPath.row]
        cell.textLabel?.font      = UIFont.regularFont(ofSize: AdaptFontSize(15))
        cell.textLabel?.textColor = UIColor.black2
        cell.accessoryType        = .disclosureIndicator
        cell.separatorInset       = UIEdgeInsets(top: 0, left: AdaptSize(15), bottom: 0, right: AdaptSize(15))
        cell.selectionStyle       = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(42)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(50)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        YRRouter.sharedInstance().currentViewController()?.hidesBottomBarWhenPushed = true
        let vc = YXMyClassDetailViewController()
        YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
        YRRouter.sharedInstance().currentViewController()?.hidesBottomBarWhenPushed = false
    }
}
