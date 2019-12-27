//
//  YXReviewViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewViewController: YXTableViewController {
        
    var headerView = YXReviewHeaderView()
    var footerView = YXReviewPlanEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isMonitorNetwork = true
        self.configTableView()
        
        self.headerBeginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(41 + kSafeBottomMargin))
            make.left.right.bottom.equalToSuperview()
//            make.bottom.equalTo(AS(-kTabBarHeight))
        }
    }
    
    override func monitorNetwork(isReachable: Bool) {
        if dataSource.count == 0 && isReachable {
            self.fetchData()
        }
    }
        
    override func refreshData() {
        self.fetchData()
    }
    
    func configTableView() {
        self.configHeaderView()
        self.configFooterView()
        
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(YXReviewPlanTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewPlanTableViewCell")
    }
    
    
    func configHeaderView() {
        self.headerView.size = CGSize(width: screenWidth, height: AS(453.5))
        
        self.headerView.startReviewEvent = { [weak self] in
            self?.startReviewEvent()
        }
        self.headerView.createReviewPlanEvent = { [weak self] in
             self?.createReviewEvent()
         }
        self.headerView.favoriteEvent = { [weak self] in
            self?.favoriteEvent()
        }
        self.headerView.wrongWordEvent = { [weak self] in
            self?.wrongWordEvent()
        }
    }
    
    
    func configFooterView() {
        self.footerView.size = CGSize(width: screenWidth, height: AS(251))
        self.footerView.createReviewPlanEvent = { [weak self] in
            self?.createReviewEvent()
        }
    }
    
    
    
    func fetchData() {
        YXReviewDataManager().fetchReviewPlanData { [weak self] (pageModel, errorMsg) in
            guard let self = self else { return }
            if let msg = errorMsg {
                UIView.toast(msg)
            } else {
                self.headerView.reviewModel = pageModel
                self.dataSource = pageModel?.reviewPlans ?? []
                
                if self.dataSource.count == 0 {
                    self.tableView.tableFooterView = self.footerView
                } else {
                    self.tableView.tableFooterView = nil
                }
                self.tableView.reloadData()
            }
            self.finishLoading()
        }
    }
    
}

extension YXReviewViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! YXReviewPlanModel
        return YXReviewPlanTableViewCell.viewHeight(model: model)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXReviewPlanTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        tableView.separatorColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell = cell as? YXReviewPlanTableViewCell,
              let model = dataSource[indexPath.row] as? YXReviewPlanModel else {
            return
        }
        
        _cell.reviewPlanModel = model
        _cell.startListenPlanEvent = { [weak self] in
            self?.startListenPlanEvent(planId: model.planId)
        }
        _cell.startReviewPlanEvent = { [weak self] in
            self?.startReviewPlanEvent(planId: model.planId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! YXReviewPlanModel
        
        let vc = YXReviewPlanDetailViewController()
        vc.planId = model.planId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension YXReviewViewController {
    
    func favoriteEvent() {
        YRRouter.openURL("word/list", query: ["type" : YXWordListType.collected], animated: true)
    }
    
    func wrongWordEvent() {
        YRRouter.openURL("word/list", query: ["type" : YXWordListType.wrongWords], animated: true)
    }
    
    /// 智能复习
    func startReviewEvent() {
//        YRRouter.openURL("exercise/study", query: ["type" : YXExerciseDataType.aiReview.rawValue], animated: true)
        
        let vc = YXExerciseViewController()
        vc.dataType = .aiReview
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 开始复习 —— 复习计划
    func startReviewPlanEvent(planId: Int) {
//        YRRouter.openURL("exercise/study", query: ["type" : YXExerciseDataType.normalReview.rawValue], animated: true)
        
        let vc = YXExerciseViewController()
        vc.dataType = .planReview
        vc.planId = planId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 开始听力 —— 复习计划
    func startListenPlanEvent(planId: Int) {
//        let url = "exercise/study?type=" + "\(YXExerciseDataType.listenReview.rawValue)"
//        YRRouter.openURL(url, query: nil, animated: true)
        
        let vc = YXExerciseViewController()
        vc.dataType = .planListenReview
        vc.planId = planId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createReviewEvent() {
        let vc = YXMakeReviewPlanViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func reviewDetailEvent() {
//        let vc = YXReviewPlanDetailViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
