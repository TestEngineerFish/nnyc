//
//  YXReviewPlanEditView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/2.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanEditView: YXTopWindowView {
    /// 智能复习
    var editButton = UIButton()
    var removeButton = UIButton()
    
    deinit {
        editButton.removeTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
        removeButton.removeTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       self.createSubviews()
       self.bindProperty()
    }
    
       
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        self.addSubview(editButton)
        self.addSubview(removeButton)
    }

    override func bindProperty() {
        editButton.setTitle("听写练习", for: .normal)
        editButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(12))
        editButton.setTitleColor(UIColor.orange1, for: .normal)
        editButton.addTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
        
        
        removeButton.setTitle("听写练习", for: .normal)
        removeButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(12))
        removeButton.setTitleColor(UIColor.orange1, for: .normal)
        removeButton.addTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
       
//        editButton.snp.makeConstraints { (make) in
//            make.centerY.left.equalToSuperview()
//            make.width.equalTo(AS(27))
//            make.height.equalTo(AS(45))
//        }
//        
//        removeButton.snp.makeConstraints { (make) in
//            make.centerY.left.equalToSuperview()
//            make.width.equalTo(AS(27))
//            make.height.equalTo(AS(45))
//        }

    }



    @objc private func clickEditButton() {
    
    }
    @objc private func clickRemoveButton() {
    
    }
}
