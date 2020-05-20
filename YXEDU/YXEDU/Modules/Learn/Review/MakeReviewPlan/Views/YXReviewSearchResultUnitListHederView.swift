//
//  YXReviewSearchResultUnitListHederView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewSearchResultUnitListHederView: UITableViewHeaderFooterView {
 
    var unitNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black2
        label.font      = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.hex(0xF2F2F2)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.addSubview(self.unitNameLabel)
        self.unitNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(22))
            make.right.equalToSuperview().offset(AdaptSize(-22))
            make.height.equalToSuperview()
        }
    }
    
}
