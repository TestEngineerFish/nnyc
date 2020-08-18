//
//  YXMyClassNoticeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXMyClassNoticeViewController: YXViewController, UITableViewDelegate, UITableViewDataSource  {

    var page: Int = 1
    var tableView       = UITableView(frame: .zero, style: .plain)
    var noticeModelList = [YXMyClassNoticeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestData()
    }

    private func bindProperty() {
        self.customNavigationBar?.title = "班级通知"
        self.customNavigationBar?.backgroundColor = .white
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.tableView.register(YXMyClassNoticeCell.classForCoder(), forCellReuseIdentifier: "kYXMyClassNoticeCell")
        self.tableView.gtm_addRefreshHeaderView { [weak self] in
            self?.requestData()
        }
        self.tableView.gtm_addLoadMoreFooterView { [weak self] in
            guard let self = self else { return }
            self.requestData(reload: false)
        }
        self.tableView.refreshingText("加载中")
        self.tableView.releaseToRefreshText("松开加载")
        self.tableView.refreshSuccessText("加载完成")
        self.tableView.pullDownToRefreshText("下拉刷新")
        self.tableView.releaseLoadMoreText("上拉加载更多")
        self.tableView.noMoreDataText("")
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
    private func requestData(reload: Bool = true) {
        if reload {
            self.page = 1
        }
        let request = YXMyClassRequestManager.notificationList(page: page)
        YXUtils.showHUD(self.view)
        YYNetworkService.default.request(YYStructResponse<YXMyClassNoticeListModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else {
                return
            }
            YXUtils.hideHUD(self.view)
            self.tableView.endRefreshing(isSuccess: true)
            if self.page == 1 {
                self.noticeModelList = model.list
            } else {
                self.noticeModelList += model.list
            }
            self.page += model.hasMore ? 1 : 0
            self.tableView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            YXUtils.hideHUD(self.view)
            self.tableView.endRefreshing(isSuccess: true)
            YXUtils.showHUD(nil, title: error.message)
        }

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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
