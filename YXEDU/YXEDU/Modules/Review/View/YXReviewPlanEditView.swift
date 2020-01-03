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
    var mainPoint: CGPoint = .zero
    
    deinit {
        editButton.removeTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
        removeButton.removeTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }
    
    init(point: CGPoint) {
        super.init(frame: .zero)
        self.mainPoint = point
        
        self.createSubviews()
        self.bindProperty()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = AS(7)
        self.layer.setDefaultShadow()
    }
    
       
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        mainView.addSubview(editButton)
        mainView.addSubview(removeButton)
    }

    override func bindProperty() {
        editButton.setTitle("编辑名称", for: .normal)
        editButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(14))
        editButton.setTitleColor(UIColor.black1, for: .normal)
        editButton.setTitleColor(UIColor.black4, for: .highlighted)
        editButton.addTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
        
        
        removeButton.setTitle("删除词单", for: .normal)
        removeButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(14))
        removeButton.setTitleColor(UIColor.red1, for: .normal)
        removeButton.setTitleColor(UIColor.black4, for: .highlighted)
        removeButton.addTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(kNavHeight + 50))
            make.left.equalTo(AS(109))
            make.width.equalTo(AS(117))
            make.height.equalTo(AS(85))
        }
       
        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(AS(15))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(57))
            make.height.equalTo(AS(20))
        }

        removeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(57))
            make.height.equalTo(AS(20))
            make.bottom.equalTo(AS(-15))
        }

    }



    @objc private func clickEditButton() {
    
    }
    @objc private func clickRemoveButton() {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
