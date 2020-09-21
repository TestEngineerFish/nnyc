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
    var isShowEmpty = false
    
    var feedbackList = [YXFeedbackReplyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.requestFeedbackReply()
    }
    
    private func bindProperty() {
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.customNavigationBar?.title = "我的消息"
        self.tableView.separatorInset   = UIEdgeInsets(top: 0, left: screenWidth, bottom: 0, right: 0)
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
        tableView.register(UINib(nibName: "YXWordListEmptyCell", bundle: nil), forCellReuseIdentifier: "YXWordListEmptyCell")
    }
    
    // MARK: ---- request ----
    /// 获得反馈回复内容
    private func requestFeedbackReply() {
        let request = YXFeedbackRequest.feedbackReply
        YYNetworkService.default.request(YYStructDataArrayResponse<YXFeedbackReplyModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let modelList = response.dataArray else {
                return
            }
            self.feedbackList = modelList
            self.isShowEmpty = self.feedbackList.isEmpty
            self.tableView.reloadData()
            self.reportReply()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
    
    /// 反馈回复已读上报
    private func reportReply() {
        let idList = self.feedbackList.compactMap { (model) -> Int? in
            if model.isRead {
                return nil
            }
            return model.id
        }
        let request = YXFeedbackRequest.reporyReply(ids: idList.toJson())
        YYNetworkService.default.request(YYStructResponse<YXChallengeUnlockModel>.self, request: request, success: { (response) in
            guard let model = response.data else {
                return
            }
            if model.state == 1 {
                UIApplication.shared.applicationIconBadgeNumber = 0
                YXRedDotManager.share.updateFeedbackReplyBadge()
            }
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }
    
    // MARK: ---- UITableViewDelegate ----
    
    
    // MARK: ---- UITableViewDataSource ----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackList.isEmpty && self.isShowEmpty ? 1 : feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.feedbackList.isEmpty {
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: "YXWordListEmptyCell") as? YXWordListEmptyCell else {
                return UITableViewCell()
            }
            emptyCell.descLabel.text = "您还没有收到回复消息"
            return emptyCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "kYXFeedbackCell") as? YXFeedbackCell else {
                return UITableViewCell()
            }
            let model = self.feedbackList[indexPath.row]
            cell.setData(model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.feedbackList.isEmpty {
            return AdaptSize(356)
        } else {
            let model = self.feedbackList[indexPath.row]
            let contentH = model.content?.textHeight(font: UIFont.regularFont(ofSize: AdaptFontSize(14)), width: screenWidth - AdaptSize(30)) ?? 0
            return contentH + AdaptSize(61)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
