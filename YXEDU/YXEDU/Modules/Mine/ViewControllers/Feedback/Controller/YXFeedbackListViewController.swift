//
//  YXFeedbackListViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXFeedbackListViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    
    var feedbackList = [YXFeedbackModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestData()
    }
    
    private func bindProperty() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.customNavigationBar?.title = "我的消息"
        self.tableView.separatorInset   = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.tableView.register(YXFeedbackCell.classForCoder(), forCellReuseIdentifier: "kYXFeedbackCell")
    }
    
    private func createSubviews() {
        self.view.addSubview(tableView)
        self.view.sendSubviewToBack(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
    }
    
    // MARK: ---- request ----
    private func requestData() {
        self.feedbackList = []
        for index in 0..<10 {
            var model = YXFeedbackModel()
            if index%2 > 0 {
                model.content = "Swift 代码被编译和优化，以充分利用现代硬件。语法和标准库是基于指导原则设计的，编写代码的明显方式也应该是最好的。安全性和速度的结合使得 Swift 成为从 “Hello，world！” 到整个操作系统的绝佳选择。"
                model.isNew   = true
            } else {
                model.content = "Swift 通过采用现代编程模式来避免大量常见编程错误"
                model.isNew   = false
            }
            self.feedbackList.append(model)
        }
        self.tableView.reloadData()
    }
    
    // MARK: ---- UITableViewDelegate ----
    
    
    // MARK: ---- UITableViewDataSource ----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXFeedbackCell") as? YXFeedbackCell else {
            return UITableViewCell()
        }
        let model = self.feedbackList[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.feedbackList[indexPath.row]
        let contentH = model.content?.textHeight(font: UIFont.regularFont(ofSize: AdaptSize(14)), width: screenWidth - AdaptSize(30)) ?? 0
        return contentH + AdaptSize(61)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
