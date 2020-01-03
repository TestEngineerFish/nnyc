//
//  YXReviewPlanEditView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/2.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanEditView: YXTopWindowView {
    
    var planId: Int = 0
    
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
    }
    
       
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        mainView.addSubview(editButton)
        mainView.addSubview(removeButton)
    }

    override func bindProperty() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = AS(7)
        self.layer.setDefaultShadow()
        
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
        let pid = self.planId
        
        // 显示弹框
        let placeholder = "请输入复习计划名称"
        let alertView = YXAlertView(type: .inputable, placeholder: placeholder)
        alertView.titleLabel.text = "请设置复习计划名称"
        alertView.doneClosure = {(text: String?) in

            guard let planName = text, placeholder != planName else { return }
            YXReviewDataManager().updateReviewPlanName(planId: pid, planName: planName) { (result, msg) in
                if let r = result, r {
                    NotificationCenter.default.post(name: YXNotification.kCloseResultPage, object: nil)
                    NotificationCenter.default.post(name: YXNotification.kUpdatePlanName, object: nil)
                    UIView.toast("修改成功")
                } else {
                    UIView.toast(msg)
                }
            }
            
        }
        alertView.show()
        
        self.removeFromSuperview()
    }
    
    @objc private func clickRemoveButton() {
        let removeView = YXReviewPlanRemoveView()
        removeView.planId = planId
        removeView.show()
        
        self.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}






class YXReviewPlanRemoveView: YXTopWindowView {
    
    var planId: Int = 0
    
    var titleLabel = UILabel()
    var removeButton = UIButton()
    var cancelButton = UIButton()
    
    deinit {
        removeButton.removeTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
        cancelButton.removeTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
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
        mainView.addSubview(titleLabel)
        mainView.addSubview(removeButton)
        mainView.addSubview(cancelButton)
    }

    override func bindProperty() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = AS(7)
                        
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
        titleLabel.textColor = UIColor.black
        titleLabel.text = "该复习计划删除后无法恢复\n是否确认删除？"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        
        removeButton.layer.masksToBounds = true
        removeButton.layer.cornerRadius = AS(20)
        removeButton.layer.borderColor = UIColor.black6.cgColor
        removeButton.layer.borderWidth = 0.5
        removeButton.setTitle("删除", for: .normal)
        removeButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(17))
        removeButton.setTitleColor(UIColor.red1, for: .normal)
        removeButton.setTitleColor(UIColor.black4, for: .highlighted)
        removeButton.addTarget(self, action: #selector(clickRemoveButton), for: .touchUpInside)
        
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = AS(20)
        cancelButton.layer.borderColor = UIColor.black6.cgColor
        cancelButton.layer.borderWidth = 0.5
        cancelButton.setTitle("点错了", for: .normal)
        cancelButton.setTitleColor(UIColor.black1, for: .normal)
        cancelButton.setTitleColor(UIColor.black4, for: .highlighted)
        cancelButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(17))
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(300))
            make.height.equalTo(AS(174))
        }
       
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(31))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(181))
            make.height.equalTo(AS(42))
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.left.equalTo(AS(19))
            make.width.equalTo(AS(125))
            make.height.equalTo(AS(40))
            make.bottom.equalTo(AS(-30))
        }

        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(AS(-19))
            make.width.equalTo(AS(125))
            make.height.equalTo(AS(40))
            make.bottom.equalTo(AS(-30))
        }

    }



    @objc private func clickRemoveButton() {
        YXReviewDataManager().removeReviewPlan(planId: planId) { [weak self] (result, msg) in
            if let r = result, r {
                self?.removeFromSuperview()
                YRRouter.popViewController(true)
                NotificationCenter.default.post(name: YXNotification.kCloseResultPage, object: nil)
                UIView.toast("删除成功")
            } else {
                UIView.toast(msg)
            }
        }
    }
    
    
    @objc private func clickCancelButton() {
        self.removeFromSuperview()
    }
    
}