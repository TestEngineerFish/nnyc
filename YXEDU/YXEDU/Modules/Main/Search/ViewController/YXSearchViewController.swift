//
//  YXSearchViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSearchViewController: YXTableViewController {
    var tableHeaderView = YXSearchTableHeaderView()
    var headerView = YXSearchHeaderView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isHideRefresh = true
        self.createSubviews()
        self.configTableView()
        self.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 41)
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(86 + kSafeBottomMargin)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    func createSubviews() {
        self.view.addSubview(headerView)
    }
    
    
    func configTableView() {
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.register(YXSearchTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSearchTableViewCell")
    }
    
    func fetchData() {
        
        YXSearchDataManager().searchData(keyword: "boo")  { [weak self] (model, errorMsg) in
            guard let self = self else { return }
            self.finishLoading()
            if let msg = errorMsg {
                UIView.toast(msg)
            } else {
                self.dataSource = model?.words ?? []
                
                if self.dataSource.count == 0 {
                    self.isHiddenEmptyView = false
                }
                
                self.tableView.reloadData()
            }
        }
    }
}



extension YXSearchViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource[indexPath.row] as! YXSearchWordModel
        return YXSearchTableViewCell.viewHeight(model: model)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSearchTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        tableView.separatorColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell = cell as? YXSearchTableViewCell else { return }
        _cell.model = dataSource[indexPath.row] as? YXSearchWordModel
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = YXReviewPlanDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension YXSearchViewController {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return UIView() // search_empty_data
    }
}
