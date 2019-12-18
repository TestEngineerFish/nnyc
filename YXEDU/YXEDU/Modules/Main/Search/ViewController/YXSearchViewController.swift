//
//  YXSearchViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/17.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSearchViewController: YXTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHideRefresh = true
        self.fetchData()
    }
    
    
    func configTableView() {
        
    }
    
    override func refreshData() {
        self.fetchData()
    }
    
    func fetchData() {
        
        YXSearchDataManager().searchData(keyword: "boo")  { [weak self] (model, errorMsg) in
            guard let self = self else { return }
            self.finishLoading()
            if let msg = errorMsg {
                
            } else {
                
            }
        }
    }
}
