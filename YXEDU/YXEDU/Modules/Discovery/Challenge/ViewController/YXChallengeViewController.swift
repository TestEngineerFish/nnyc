//
//  YXChallengeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeViewController: YXViewController, UITableViewDelegate, UITableViewDataSource {

    final let kYXChallengeRankCell   = "YXChallengeRankCell"

    var challengeModel: YXChallengeModel?
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        let tableViewSize = CGSize(width: screenWidth, height: screenHeight - tabBar_Height - kSafeBottomMargin + kStatusBarHeight)
        self.view.backgroundColor = UIColor.gradientColor(with: tableViewSize, colors: [UIColor.hex(0xFEDC4A), UIColor.hex(0xFDAD2F)], direction: .vertical)
        self.setSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestChallengeData()
        YXAlertCheckManager.default.checkLatestBadgeWhenBackTabPage()
    }

    private func setSubviews() {
        self.view.addSubview(tableView)
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
        self.tableView.separatorStyle  = .none
        self.tableView.showsVerticalScrollIndicator   = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.register(YXChallengeRankCell.classForCoder(), forCellReuseIdentifier: kYXChallengeRankCell)
        self.tableView.backgroundColor = UIColor.clear
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
            if let version = self.challengeModel?.gameInfo?.gameLinedId {
                self.checkShowResult(version)
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error.message)")
        }
    }

    private func requestUnlockGame() {
        let request = YXChallengeRequest.unlock
        YYNetworkService.default.request(YYStructResponse<YXChallengeUnlockModel>.self, request: request, success: { (response) in
            if let statusModel = response.data, statusModel.state == 1 {
                self.requestChallengeData()
            } else {
                self.showGoldLackAlert()
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error.message)")
        }
    }

    /// 是否向用户展示过上期排名
    private func checkShowResult(_ version: Int) {
        let request = YXChallengeRequest.showPrevious(version: version)
        YYNetworkService.default.request(YYStructResponse<YXChallengeUnlockModel>.self, request: request, success: { (response) in
            if let data = response.data, data.state == 0 {
                self.requestPreviousResult()
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error.message)")
        }
    }

    /// 展示上期结果弹框
    private func requestPreviousResult() {
        let request = YXChallengeRequest.rankedList
        YYNetworkService.default.request(YYStructResponse<YXChallengeModel>.self, request: request, success: { (response) in
            guard let challengeModel = response.data, let userModel = challengeModel.userModel, userModel.ranking > 0 else {
                return
            }
            let previousResultView = YXPreviousResultView()
            previousResultView.bindData(userModel)
            kWindow.addSubview(previousResultView)
            previousResultView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error)")
        }
    }

    // MARK: ==== Event ====
    @objc private func clickPlayButton(){
//        let vc = YXLearningResultViewController()
//        vc.bookId = 1
//        vc.unitId = 1
//        vc.newLearnAmount = 1
//        vc.reviewLearnAmount = 1

//        RegisterSliderView.show(.puzzle) { (success) in
//            print(success)
//        }
//        return
//        let vc = YXShareViewController()
//        vc.gameModel = YXGameResultModel()
//        vc.shareType = .challengeResult
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
//            YXShareCordeView.share.showView("分享给你这次要复习的单词计划：【测试1111】，复制口令后打开念念有词App，就能马上开始学习 分享口令：￥FSUL91YHQiYrW￥")
//        return
        guard let challengeModel = self.challengeModel, let gameInfo = challengeModel.gameInfo, let userModel = challengeModel.userModel else {
            return
        }

        switch userModel.gameStatus {
        case .lock:
            let alertView = YXAlertView(type: .normal)
            alertView.descriptionLabel.text = "确定花费\(gameInfo.unlockCoin)松鼠币解锁游戏吗？"
            alertView.doneClosure = { _ in
                if userModel.myCoins >= gameInfo.unlockCoin {
                    self.requestUnlockGame()
                } else {
                    self.showGoldLackAlert()
                }
            }
            alertView.show()
        case .task:
            let alertView = YXAlertView(type: .normal)
            alertView.descriptionLabel.text = "背完今天的单词可以获得一次免费挑战机会！"
            alertView.leftButton.setTitle("直接挑战", for: .normal)
            alertView.rightOrCenterButton.setTitle("去背单词", for: .normal)
            alertView.cancleClosure = {
                if userModel.myCoins >= gameInfo.unitCoin {
                    self.playGame()
                } else {
                    self.showGoldLackAlert()
                }
            }
            alertView.doneClosure = { _ in
                self.tabBarController?.selectedIndex = 0
            }
            alertView.show()
        case .free:
            self.playGame()
        case .again:
            if userModel.myCoins < gameInfo.unitCoin {
                self.showGoldLackAlert()
            } else {
                self.playGame()
            }
        }
    }

    private func playGame() {
        let vc = YXGameViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.gameLineId = self.challengeModel?.gameInfo?.gameLinedId
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func previousRank() {
        let vc = YXPreviousRankViewController()
        vc.gameVersion = 2
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func showGoldLackAlert() {
        let alertView = YXAlertView(type: .normal)
        alertView.descriptionLabel.text = "您的松果币余额不足，建议去任务中心看看哦"
        alertView.rightOrCenterButton.setTitle("我知道了", for: .normal)
        alertView.shouldOnlyShowOneButton = true
        alertView.show()
    }
    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let amount = self.challengeModel?.rankedList.count ?? 0
        return amount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YXChallengeHeaderView(false)
        headerView.headerView.startButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        headerView.previousRankButton.addTarget(self, action: #selector(previousRank), for: .touchUpInside)
        headerView.bindData(self.challengeModel)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.challengeModel, let cell = tableView.dequeueReusableCell(withIdentifier: kYXChallengeRankCell) as? YXChallengeRankCell else {
            return UITableViewCell()
        }
        let userModel = model.rankedList[indexPath.row]
        cell.bindData(userModel)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = YXChallengeFooterView()
        footerView.layoutSubviews()
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let rankedList = self.challengeModel?.rankedList, !rankedList.isEmpty else {
            return AdaptSize(337)
        }
        return AdaptSize(408)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdaptSize(67)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let rankedList = self.challengeModel?.rankedList, !rankedList.isEmpty else {
            return AdaptSize(244)
        }
        return AdaptSize(20)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -kStatusBarHeight {
            scrollView.contentOffset.y = -kStatusBarHeight
        }
    }


}

