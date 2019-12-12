//
//  YXReviewViewController.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewViewController: YXViewController {
    
    
    var headerView = YXReviewHeaderView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.bindData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.isMonitorNetwork = true
        
//        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(41 + kSafeBottomMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        
    }
    
    override func monitorNetwork(isReachable: Bool) {
        
    }

}
