//
//  YXReviewPlanListView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanTableView: YXView {
    
    var titleLabel = UILabel()
    var createButton = UIButton()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        
        self.addSubview(titleLabel)
        self.addSubview(createButton)
                
    }
    
    
    override func bindProperty() {
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        contentView.snp.makeConstraints { (make) in
//            make.left.equalTo(30)
//            make.right.equalTo(-30)
//            make.top.equalTo(50)
//            make.height.equalTo(320)
//        }
        
        
        
        
        
    }
    
    
    
}
