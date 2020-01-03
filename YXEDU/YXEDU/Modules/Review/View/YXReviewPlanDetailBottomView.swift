//
//  YXReviewPlanDetailBottomView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanShareDetailBottomView: YXView {
    
    var saveReviewPlanEvent: (() -> ())?
    
    private var saveButton = UIButton()
                
    deinit {
        saveButton.removeTarget(self, action: #selector(clickSaveButton), for: .touchUpInside)
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
        self.addSubview(saveButton)
        
    }
    
    override func bindProperty() {
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 21
        saveButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        saveButton.setTitle("保存到我的复习计划", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 17)
        saveButton.addTarget(self, action: #selector(clickSaveButton), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        saveButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.left.equalTo(AS(50))
            make.right.equalTo(AS(-50))
            make.height.equalTo(AS(42))
        }
    }

    @objc func clickSaveButton() {
        self.saveReviewPlanEvent?()
    }

}



class YXReviewPlanDetailBottomView: YXView {
    var listenEvent: (() -> ())?
    var reviewEvent: (() -> ())?
    
    var listenButton = UIButton()
    var reviewButton = UIButton()
    
    deinit {
        listenButton.removeTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
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
        self.addSubview(listenButton)
        self.addSubview(reviewButton)
    }
    
    override func bindProperty() {
        listenButton.layer.masksToBounds = true
        listenButton.layer.cornerRadius = AS(21)
        listenButton.layer.borderColor = UIColor.black6.cgColor
        listenButton.layer.borderWidth = 0.5
        listenButton.setTitle("听写练习", for: .normal)
        listenButton.setTitleColor(UIColor.black1, for: .normal)
        listenButton.setTitleColor(UIColor.black3, for: .highlighted)
        listenButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        listenButton.addTarget(self, action: #selector(clickListenButton), for: .touchUpInside)

        
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(21)
        reviewButton.layer.borderColor = UIColor.black6.cgColor
        reviewButton.layer.borderWidth = 0.5
        reviewButton.setTitle("继续复习", for: .normal)
        reviewButton.setTitleColor(UIColor.black1, for: .normal)
        reviewButton.setTitleColor(UIColor.black3, for: .highlighted)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        listenButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AS(27))
            make.width.equalTo(reviewButton)
            make.height.equalTo(AS(42))
        }
        
        reviewButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(listenButton.snp.right).offset(AS(15))
            make.right.equalTo(AS(-27))
            make.height.equalTo(AS(42))
        }
    }

    @objc func clickListenButton() {
        listenEvent?()
    }
    
    
    @objc func  clickReviewButton() {
        reviewEvent?()
    }

}
