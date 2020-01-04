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
    var searchView = YXSearchHeaderView()
    var emptyDataView = YXSearchEmptyDataView()
    
    private var dao: YXSearchHistoryDao = YXSearchHistoryDaoImpl()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isHideRefresh = true
        
        self.configHeaderView()
        self.configTableView()
        self.loadHistoryData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 41)
        
        searchView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(86 + kSafeBottomMargin)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func configHeaderView() {
        self.view.addSubview(searchView)
        searchView.searchEvent = { [weak self] (text) in
            self?.fetchData(text: text)
        }
        
        tableHeaderView.removeEvent = {
            let alertView = YXAlertView()
            alertView.titleLabel.text = "确定要清空搜索记录吗？"
            alertView.leftButton.setTitle("清空", for: .normal)
            alertView.rightOrCenterButton.setTitle("取消", for: .normal)
            alertView.doneClosure = { (text) in
                
            }
            alertView.show()
        }
    }
    
    
    func configTableView() {
        self.tableView.register(YXSearchTableViewCell.classForCoder(), forCellReuseIdentifier: "YXSearchTableViewCell")
    }
    
    func fetchData(text: String) {
        if text.count == 0 {
            self.isHiddenEmptyView = true
            loadHistoryData()
            return
        }
        YXSearchDataManager().searchData(keyword: text)  { [weak self] (model, errorMsg) in
            guard let self = self else { return }
            self.finishLoading()
            if let msg = errorMsg {
                UIView.toast(msg)
            } else {
                self.dataSource = model?.words ?? []
                if self.dataSource.count == 0 {
                    self.isHiddenEmptyView = false
                }
                self.tableView.tableHeaderView = nil
                self.tableView.reloadData()
            }
        }
    }
    
    func loadHistoryData() {
        
        self.dataSource = dao.selectWord()
        
        if self.dataSource.count == 0 {
            self.isHiddenEmptyView = false
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = tableHeaderView
        }
        
        self.tableView.reloadData()
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
        
        guard let model = dataSource[indexPath.row] as? YXSearchWordModel else { return }
        let result = dao.insertWord(word: model)
        print(result)
        
        let home = UIStoryboard(name: "Home", bundle: nil)
        let wordDetialViewController = home.instantiateViewController(withIdentifier: "YXWordDetailViewControllerNew") as! YXWordDetailViewControllerNew
        wordDetialViewController.wordId = model.wordId ?? 0
        wordDetialViewController.isComplexWord = model.isComplexWord ?? 0
        self.navigationController?.pushViewController(wordDetialViewController, animated: true)
        
    }
}


extension YXSearchViewController {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        emptyDataView.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.height.equalTo(299)
        }
        return emptyDataView
    }
    
    override func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -(tableView.height - 299) / 2 + 37
    }
}
