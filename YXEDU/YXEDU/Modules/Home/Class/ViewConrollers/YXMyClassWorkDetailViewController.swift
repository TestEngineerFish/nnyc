//
//  YXMyClassWorkDetailViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassWorkDetailViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "作业报告"
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(YXMyClassWorkDetailCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassWorkDetailCell")
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassWorkDetailHeaderView()
        headerView.setData()
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassWorkDetailCell", for: indexPath) as? YXMyClassWorkDetailCell else {
            return UITableViewCell()
        }
        cell.setData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(77)
    }
}
