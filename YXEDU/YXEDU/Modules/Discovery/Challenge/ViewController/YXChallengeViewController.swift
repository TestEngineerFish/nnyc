//
//  YXChallengeViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/11.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXChallengeViewController: YXViewController {

    var headerView = YXChallengeHeaderView()
    var top3View   = YXChallengeRankTop3View()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviews()
        self.navigationController?.isNavigationBarHidden = true

    }

    private func setSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(top3View)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(297))
        }

        top3View.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(AdaptSize(-26))
            make.top.equalTo(headerView.snp.bottom).offset(AdaptSize(-20))
            make.height.equalTo(AdaptSize(205))
        }
    }
}
