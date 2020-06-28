//
//  YXMyClassTableViewFooterView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/28.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXMyClassTableViewFooterView: YXView {
    let iconImageView = UIImageView(image: UIImage(named: "emptyWorkIcon"))
    let descLabel: UILabel = {
        let label = UILabel()
        label.text      = "暂无作业"
        label.font      = UIFont.regularFont(ofSize: AdaptFontSize(14))
        label.textColor = UIColor.black3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(iconImageView)
        self.addSubview(descLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(277), height: AdaptSize(205)))
            make.top.equalToSuperview()
        }
        descLabel.sizeToFit()
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(AdaptSize(7))
            make.size.equalTo(descLabel)
        }
    }
    
}
