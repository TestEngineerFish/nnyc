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
    final let kYXChallengeRankCell   = "YXChallengeRankCell"

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
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
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
        let request = YXChallengeRequest.challengeModel
        YYNetworkService.default.request(YYStructResponse<YXChallengeModel>.self, request: request, success: { (response) in
            self.challengeModel = response.data
            self.tableView.reloadData()
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    private func requestUnlockGame() {
        let request = YXChallengeRequest.unlock
        YYNetworkService.default.request(YYStructResponse<YXChallengeUnlockModel>.self, request: request, success: { (response) in
            if let statusModel = response.data {
                if statusModel.state == 1 {
                    self.requestChallengeData()
                }
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====
    @objc private func clickPlayButton(){
        guard let challengeModel = self.challengeModel, let gameInfo = challengeModel.gameInfo, let userModel = challengeModel.userModel else {
            return
        }

        switch userModel.gameStatus {
        case .lock:
            let alertView = YXAlertView(type: .normal)
            alertView.descriptionLabel.text = "确定花费\(gameInfo.unlockCoin)松鼠币解锁游戏吗？"
            alertView.doneClosure = { _ in
                self.requestUnlockGame()
            }
            alertView.show()
        case .task:
            let alertView = YXAlertView(type: .normal)
            alertView.descriptionLabel.text = "背完今天的单词可以获得一次免费挑战机会！"
            alertView.leftButton.setTitle("直接挑战", for: .normal)
            alertView.rightOrCenterButton.setTitle("去背单词", for: .normal)
            alertView.cancleClosure = {
                self.requestUnlockGame()
            }
            alertView.doneClosure = { _ in
                print("跳转到背单词页面")
            }
            alertView.show()
        case .free:
            self.playGame()
        case .again:
            if userModel.myCoins < gameInfo.unitCoin {
                let alertView = YXAlertView(type: .normal)
                alertView.descriptionLabel.text = "您的松果币余额不足，建议去任务中心看看哦"
                alertView.rightOrCenterButton.setTitle("我知道了", for: .normal)
                alertView.shouldOnlyShowOneButton = true
                alertView.show()
            } else {
                self.playGame()
            }
        }

    }

    private func playGame() {
        let vc = YXGameViewController()
        //        let vc = YXShareViewController()
        //        vc.titleString = "挑战分享"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func previousRank() {
        let vc = YXPreviousRankViewController()
        vc.gameVersion = 2
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func showRuleView() {
        YXAlertWebView.share.show("http://www.baidu.com")
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount = self.challengeModel?.rankedList.count ?? 0
        if amount >= 3 {
            /// 移除前三名,默认显示自己当前状态
            return amount - 3 + 1
        } else if amount == 0 {
            return 0
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = self.challengeModel else {
            return nil
        }
        let view = UIView()
        view.backgroundColor = UIColor.hex(0xE9DDC4)
        view.addSubview(headerView)
        view.addSubview(top3View)
        headerView.startButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        headerView.previousRankButton.addTarget(self, action: #selector(previousRank), for: .touchUpInside)
        headerView.gameRuleButton.addTarget(self, action: #selector(showRuleView), for: .touchUpInside)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(297))
        }

        top3View.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-25))
            make.top.equalTo(headerView.snp.bottom).offset(AdaptSize(-13))
            make.bottom.equalToSuperview()
        }
        headerView.bindData(model)
        let top3ModelList = Array(model.rankedList.prefix(3))
        top3View.bindData(top3ModelList)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.challengeModel else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            let cell = YXChallengeMyRankCell(style: .default, reuseIdentifier: nil)
            guard let userModel = model.userModel else {
                return cell
            }
            cell.bindData(userModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kYXChallengeRankCell) as? YXChallengeRankCell, indexPath.row + 2 < model.rankedList.count else {
                return UITableViewCell()
            }
            let otherUserModel = model.rankedList[indexPath.row + 2]
            cell.bindData(otherUserModel)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = YXChallengeFooterView()
        footerView.layoutSubviews()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let rankedList = self.challengeModel?.rankedList, rankedList.isEmpty else {
            return AdaptSize(481)
        }
        return AdaptSize(583)

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.requestChallengeData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -kStatusBarHeight {
            scrollView.contentOffset.y = -kStatusBarHeight
        }
    }


}
 
