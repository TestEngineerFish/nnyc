//
//  YXMyClassViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange1
        return view
    }()
    
    var workTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func bindProperty() {
        self.customNavigationBar?.title           = "班级"
        self.customNavigationBar?.titleColor      = UIColor.white
        self.customNavigationBar?.backgroundColor = .orange1
        self.customNavigationBar?.leftButtonTitleColor = .white
        self.workTableView.delegate        = self
        self.workTableView.dataSource      = self
        self.workTableView.register(YXWorkWithMyClassCell.classForCoder(), forCellReuseIdentifier: "kYXWorkWithMyClassCell")
        self.workTableView.backgroundColor = .clear
    }

    private func createSubviews() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(workTableView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(AdaptSize(58) + kNavHeight)
        }
        workTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        }
        if self.customNavigationBar != nil {
            self.view.bringSubviewToFront(self.customNavigationBar!)
        }
    }

    // MARK: ==== UITableViewDateSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    var classList = ["2班", "8090班", "1115班"]

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyWorkTableViewHeaderView()
        headerView.setDate(classList: classList)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXWorkWithMyClassCell", for: indexPath) as? YXWorkWithMyClassCell else {
            return UITableViewCell()
        }
        cell.setData(indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count  = classList.count > 3 ? 3 : classList.count
        let amount = CGFloat(96 + count * 50)
        return AdaptSize(amount)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
