//
//  YXMyClassWorkReportViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassWorkReportViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var workId: Int?
    var classId: Int?
    var reportModel: YXMyClassReportModel?

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.reloadData()
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

    // MARK: ==== Request ====
    private func reloadData() {
        guard let _workId = self.workId else {
            return
        }
        let request = YXMyClassRequestManager.workReport(workId: _workId)
        YYNetworkService.default.request(YYStructResponse<YXMyClassReportModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.reportModel = response.data
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportModel?.wordModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyClassWorkDetailHeaderView()
        headerView.setData(report: self.reportModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXMyClassWorkDetailCell", for: indexPath) as? YXMyClassWorkDetailCell, let modelList = self.reportModel?.wordModelList else {
            return UITableViewCell()
        }
        let model = modelList[indexPath.row]
        cell.setData(word: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(77)
    }
}
