//
//  YXChallengeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    var headerView = YXChallengeHeaderView()
    var top3View   = YXChallengeRankTop3View()
    final let kYXChallengeRankCell = "YXChallengeRankCell"

    var challengeModel: YXChallengeModel?
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hex(0xE9DDC4)
        self.setSubviews()
        self.requestChallengeData()
    }

    private func setSubviews() {
        self.view.addSubview(tableView)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle  = .none
        self.tableView.backgroundColor = UIColor.hex(0xE9DDC4)
        self.tableView.register(YXChallengeRankCell.classForCoder(), forCellReuseIdentifier: kYXChallengeRankCell)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-kStatusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: ==== Request ====
    private func requestChallengeData() {
        let request = YXChallengeRequest.challengeModel(flag: "")
        YYNetworkService.default.request(YYStructResponse<YXChallengeModel>.self, request: request, success: { (response) in
            self.challengeModel = response.data
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====
    @objc private func playGame(){
//        let vc = YXGameViewController()
        let vc = YXShareViewController()
        vc.titleString = "挑战分享"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }


    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengeModel?.rankedList.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = self.challengeModel else {
            return nil
        }
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xE9DDC4)
        view.addSubview(headerView)
        view.addSubview(top3View)
        headerView.startButton.addTarget(self, action: #selector(playGame), for: .touchUpInside)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(297))
        }

        top3View.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-26))
            make.top.equalTo(headerView.snp.bottom).offset(AdaptSize(-26))
            make.bottom.equalToSuperview()
        }
        headerView.bindData(model)
        let top3ModelList = Array(model.rankedList.prefix(3))
        top3View.bindData(top3ModelList)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.challengeModel, let cell = tableView.dequeueReusableCell(withIdentifier: kYXChallengeRankCell) as? YXChallengeRankCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            guard let userModel = model.userModel else {
                return cell
            }
            cell.bindData(userModel)
            cell.showCnallengeResultView(userModel)
        } else {
            let otherUserModel = model.rankedList[indexPath.row]
            cell.bindData(otherUserModel)
            if indexPath.row == 1 {
                cell.showArrowLayer(otherUserModel)
            } else if indexPath.row == model.rankedList.count - 1 {
                cell.showBottomRadius()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(481)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return AdaptSize(81)
        } else {
            return AdaptSize(67)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.requestChallengeData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            print(scrollView.contentOffset.y)
        }
    }


}
 
