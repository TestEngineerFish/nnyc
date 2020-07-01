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

    var classModelList = [YXMyClassModel]()
    var workListModel: YXMyWorkListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.reloadData()
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: YXNotification.kJoinClass, object: nil)
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

    // MARK: ==== Request ====
    private func requestClassList() {
        let request = YXMyClassRequestManager.classList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXMyClassModel>.self, request: request, success: { (response) in
            guard let modelList = response.dataArray else {
                return
            }
            self.classModelList = modelList
            self.workTableView.reloadData()
            if self.classModelList.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    private func requestWorkList() {
        let request = YXMyClassRequestManager.workList
        YYNetworkService.default.request(YYStructResponse<YXMyWorkListModel>.self, request: request, success: { (response) in
            guard let listModel = response.data else {
                return
            }
            self.workListModel = listModel
            self.workTableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    // MARK: ==== Event ====
    @objc private func reloadData() {
        self.requestClassList()
        self.requestWorkList()
    }

    // MARK: ==== UITableViewDateSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workListModel?.workModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXMyWorkTableViewHeaderView()
        headerView.setDate(class: self.classModelList)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXWorkWithMyClassCell", for: indexPath) as? YXWorkWithMyClassCell, let listModel = self.workListModel else {
            return UITableViewCell()
        }
        let model = listModel.workModelList[indexPath.row]
        cell.setData(work: model, hashDic: listModel.bookHash)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count  = self.classModelList.count > 3 ? 3 : self.classModelList.count
        let amount = CGFloat(96 + count * 50)
        return AdaptSize(amount)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let workModelList = self.workListModel?.workModelList, !workModelList.isEmpty else {
            return AdaptSize(232)
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = YXMyClassTableViewFooterView()
        return footerView
    }
}
