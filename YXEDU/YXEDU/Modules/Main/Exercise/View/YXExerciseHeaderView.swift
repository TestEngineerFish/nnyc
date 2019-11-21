//
//  YXExerciseHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习模块：顶部view
class YXExerciseHeaderView: UIView {
    
    var backEvent: (() -> Void)?
    var switchEvent: (() -> Void)?
    
    var learningProgress: String? {
        didSet {
            self.learningProgressLabel.text = learningProgress
        }
    }
    
    var reviewProgress: String? {
        didSet {
            self.reviewProgressLabel.text = reviewProgress
        }
    }
    

    //MARK: - 私有属性
    private var backButton: UIButton = UIButton()
    private var switchButton: UIButton = UIButton()
    
    private var learningLabel: UILabel = UILabel()
    private var reviewLabel: UILabel = UILabel()
    
    private var learningProgressLabel: UILabel = UILabel()
    private var reviewProgressLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews() {
        self.addSubview(backButton)
        self.addSubview(switchButton)
        self.addSubview(learningLabel)
        self.addSubview(reviewLabel)
        self.addSubview(learningProgressLabel)
        self.addSubview(reviewProgressLabel)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        
        self.backButton.setBackgroundImage(UIImage(named: "exercise_quit"), for: .normal)
        self.backButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        
        
        self.switchButton.setTitle("测试-清空数据", for: .normal)
        self.switchButton.setTitleColor(UIColor.black3, for: .normal)
        self.switchButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.switchButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 12)
        self.switchButton.addTarget(self, action: #selector(clickSwitchButton), for: .touchUpInside)
        
        
        self.learningLabel.text = "待新学"
        self.learningLabel.textColor = UIColor.black3
        self.learningLabel.font = UIFont.regularFont(ofSize: 10)
        
        self.reviewLabel.text = "待复习"
        self.reviewLabel.textColor = UIColor.black3
        self.reviewLabel.font = UIFont.regularFont(ofSize: 10)
        
        
        self.learningProgressLabel.text = "20"
        self.learningProgressLabel.textColor = UIColor.orange1
        self.learningProgressLabel.font = UIFont.regularFont(ofSize: 10)
        
        self.reviewProgressLabel.text = "20"
        self.reviewProgressLabel.textColor = UIColor.orange1
        self.reviewProgressLabel.font = UIFont.regularFont(ofSize: 10)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.equalTo(22)
            make.height.equalTo(25)
        }
        
        self.switchButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(17)
        }
        
        self.learningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-38)
            make.width.equalTo(31)
            make.height.equalTo(14)
        }
        self.reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-38)
            make.width.equalTo(32)
            make.height.equalTo(14)
            make.bottom.equalTo(0)
        }
        
        self.learningProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(learningLabel.snp.right).offset(2)
            make.right.equalTo(0)
            make.height.equalTo(14)
        }
        
        self.reviewProgressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(2)
            make.right.equalTo(0)
            make.height.equalTo(14)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    
    @objc func clickBackButton() {
        self.backEvent?()
    }
    
    @objc func clickSwitchButton() {
        self.switchEvent?()
    }
}
