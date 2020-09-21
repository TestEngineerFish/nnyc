//
//  YXTableViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/14.
//  Copyright © 2019 sunwu. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class YXTableViewController: YXViewController, YYScrollRefreshAnimator {
    
    /// 数据源
    var dataSource: [Any] = []
    
    /// TableView
    var tableView = UITableView(frame: .zero, style: .plain)
    
    /// 是否隐藏空面板
    var isHiddenEmptyView = true
    
    
    /// 上拉，加载更多
    var hasMore: Bool = false {
        didSet {
            if hasMore {
                if self.footerRefreshView == nil {
                    self.addFooterPullToRefresh { [weak self] in
                        self?.loadMoreData()
                    }
                } else {
                    self.footerEndRefreshing()
                }
            } else {
                self.footerRefreshView = nil
            }
        }
    }
    
    
    /// 是否隐藏下拉刷新
    var isHideRefresh = false {
        didSet {
            if self.isHideRefresh {
                self.headerRefreshView = nil
            } else {
                self.addHeaderPullToRefresh { [weak self] in
                    self?.refreshData()
                }
            }
        }
    }
    

    deinit {        
        tableView.delegate   = nil
        tableView.dataSource = nil
        
        tableView.emptyDataSetSource   = nil
        tableView.emptyDataSetDelegate = nil
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.emptyDataSetSource   = self
        tableView.emptyDataSetDelegate = self
        
        // 隐藏了Navigation Bar, 需要消除顶部空白
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets     = false
        }
        self.edgesForExtendedLayout = []    // 好像设置了没什么效果
        
        // 清除数据还未加载时的分割线
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.001))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.001))
        
        // 设置刷新动作
        self.refreshCompomentScrollView = self.tableView
        if !self.isHideRefresh {
            self.addHeaderPullToRefresh { [weak self] in
                self?.refreshData()
            }
        }
        
    }
    
    
    // MARK: - Refresh method
    /** 刷新数据(下拉) */
    @objc func refreshData() {
        
    }
    
    // 加载更多数据(上拉)
    @objc func loadMoreData() {
        
    }
    
    // 完成加载
    func finishLoading() {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }

}

extension YXTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



extension YXTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // 视图显示的条件：没有数据展示的时候
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return isHiddenEmptyView == false && self.dataSource.count  == 0
    }
    
    // 以淡入的模式显示
    func emptyDataSetShouldFade(in scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    // 允许滚动
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    // 垂直方向上的对齐约束
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -((self.tableView.tableHeaderView?.frame.size.height ?? 0.0) / 2.0) - scrollView.contentInset.top / 2.0
    }
}
