//
//  YXChallengeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeViewController: UIViewController {

    var headerView = YXChallengeHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviews()
        self.navigationController?.isNavigationBarHidden = true
    }

    private func setSubviews() {
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(297))
        }
    }
}
