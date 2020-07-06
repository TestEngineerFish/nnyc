//
//  YXMyClassNoticeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassNoticeViewController: YXViewController, UITableViewDelegate, UITableViewDataSource  {
    var tableView = UITableView(frame: .zero, style: .plain)
    var noticeModelList = [YXMyClassNoticeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestData()
    }

    private func bindProperty() {
        for index in 0..<10 {
            var model = YXMyClassNoticeModel()
            model.content = "暑假作业已发放，请大家注意及时查收，暑假作业已发放，请大家注意及时查收"
            model.time    = "6月12号"
            model.isNew   = index < 4
            noticeModelList.append(model)
        }
        self.customNavigationBar?.title = "班级通知"
        self.customNavigationBar?.backgroundColor = .white
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.tableView.register(YXMyClassNoticeCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassNoticeCell")
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        self.view.sendSubviewToBack(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.bottom.right.equalToSuperview()
        }
    }

    // MARK: ==== Request ====
    private func requestData() {
        self.tableView.reloadData()
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassNoticeCell") as? YXMyClassNoticeCell else {
            return UITableViewCell()
        }
        let model = self.noticeModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
