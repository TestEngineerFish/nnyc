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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        headerView.bindData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isMonitorNetwork = true
        configView()
        
        self.headerBeginRefreshing()
//        fetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(41 + kSafeBottomMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-kSafeBottomMargin - kTabBarHeight)
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
    
    func configView() {
        self.headerView.size = CGSize(width: screenWidth, height: 453.5)
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(YXReviewPlanTableViewCell.classForCoder(), forCellReuseIdentifier: "YXReviewPlanTableViewCell")
    }
    
    
    func fetchData() {
        YXReviewDataManager().fetchReviewPlanData { [weak self] (pageModel, errorMsg) in
            guard let self = self else { return }
            if let msg = errorMsg {
                UIView.toast(msg)
            } else {
                self.headerView.reviewModel = pageModel
                self.dataSource = pageModel?.reviewPlans ?? []
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
        guard let _cell = cell as? YXReviewPlanTableViewCell else { return }
        
        _cell.reviewPlanModel = dataSource[indexPath.row] as? YXReviewPlanModel
    }
}
