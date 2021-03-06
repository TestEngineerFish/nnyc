//
//  YXPreviousRankViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXPreviousRankViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var gameVersion: Int?
    var challengeModel: YXChallengeModel?
    var tableView = UITableView(frame: .zero, style: .grouped)
    final let kYXChallengeRankCell   = "YXChallengeRankCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createSubviews()
        self.requestChallengeData()
    }

    private func createSubviews() {
        self.view.addSubview(tableView)
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
        self.tableView.separatorStyle  = .none
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(YXChallengeRankCell.classForCoder(), forCellReuseIdentifier: kYXChallengeRankCell)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(10))
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: ==== Request ====
    private func requestChallengeData() {
        let request = YXChallengeRequest.rankedList
        YYNetworkService.default.request(YYStructResponse<YXChallengeModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self else { return }
            self.challengeModel = response.data
            self.customNavigationBar?.title = "上期排行"
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    // MARK: ==== UITableViewDelegate & UItableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengeModel?.rankedList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView   = YXChallengeHeaderView(true)
        headerView.bindData(self.challengeModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.challengeModel else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXChallengeRankCell) as? YXChallengeRankCell, indexPath.row <= model.rankedList.count else {
            return UITableViewCell()
        }
        let otherUserModel = model.rankedList[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.bindData(otherUserModel)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = YXChallengeFooterView()
        footerView.layoutSubviews()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(140)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row == 0 {
             return AdaptSize(81)
         } else {
             return AdaptSize(67)
         }
     }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let rankedList = self.challengeModel?.rankedList else {
            return AdaptSize(20)
        }
        if rankedList.count > 3 {
            return AdaptSize(20)
        } else {
            return AdaptSize(30)
        }
    }
}
