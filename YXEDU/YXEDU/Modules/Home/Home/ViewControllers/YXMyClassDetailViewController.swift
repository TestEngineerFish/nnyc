//
//  YXMyClassDetailViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassDetailViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var dataList = [1, 2, 3]
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProprety()
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(kNavHeight))
        }
    }

    private func bindProprety() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.customNavigationBar?.title = "班级详情"
        self.customNavigationBar?.rightButton.setImage(UIImage(named: "more_black"), for: .normal)
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(80)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassDetailHeaderView()
        headerView.setData()
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = YXMyClassStudentCell()
        cell.setData()
        return cell
    }
}
