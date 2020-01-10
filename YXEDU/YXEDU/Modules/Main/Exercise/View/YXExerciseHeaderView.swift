//
//  YXExerciseHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXExerciseHeaderViewProtocol: NSObjectProtocol {
    /// 点击回首页按钮
    func clickHomeBtnEvent()
    /// 点击切题按钮
    func clickSwitchBtnEvent()
    /// 点击跳过按钮
    func clickSkipBtnEvent()
}

/// 练习模块：顶部view
class YXExerciseHeaderView: UIView {

    weak var delegate: YXExerciseHeaderViewProtocol?
    
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
    private var skipButton: UIButton = UIButton()
    
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
        self.addSubview(skipButton)
        self.addSubview(learningLabel)
        self.addSubview(reviewLabel)
        self.addSubview(learningProgressLabel)
        self.addSubview(reviewProgressLabel)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        
        self.backButton.setBackgroundImage(UIImage(named: "exercise_quit"), for: .normal)
        self.backButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        
        self.switchButton.isHidden = true
        self.switchButton.setTitle("测试-清空", for: .normal)
        self.switchButton.setTitleColor(UIColor.black3, for: .normal)
        self.switchButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.switchButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        self.switchButton.addTarget(self, action: #selector(clickSwitchButton), for: .touchUpInside)
        
        self.skipButton.isHidden = true
        self.skipButton.setTitle("跳过", for: .normal)
        self.skipButton.setTitleColor(UIColor.black3, for: .normal)
        self.skipButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.skipButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptSize(14))
        self.skipButton.addTarget(self, action: #selector(clickSkipButton), for: .touchUpInside)
        
        
        self.learningLabel.text = "待新学"
        self.learningLabel.textColor = UIColor.black3
        self.learningLabel.font = UIFont.regularFont(ofSize: AdaptSize(10))
        
        self.reviewLabel.text = "待复习"
        self.reviewLabel.textColor = UIColor.black3
        self.reviewLabel.font = UIFont.regularFont(ofSize: AdaptSize(10))
        
        
        self.learningProgressLabel.text = "20"
        self.learningProgressLabel.textColor = UIColor.orange1
        self.learningProgressLabel.font = UIFont.regularFont(ofSize: AdaptSize(10))
        
        self.reviewProgressLabel.text = "20"
        self.reviewProgressLabel.textColor = UIColor.orange1
        self.reviewProgressLabel.font = UIFont.regularFont(ofSize: AdaptSize(10))
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AdaptSize(20))
            make.width.equalTo(AdaptSize(22))
            make.height.equalTo(AdaptSize(25))
        }
        
        self.switchButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AdaptSize(100))
            make.height.equalTo(AdaptSize(17))
        }
        
        self.skipButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(AdaptSize(100))
            make.width.equalTo(AdaptSize(50))
            make.height.equalTo(AdaptSize(17))
        }
        
        self.learningLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.right.equalTo(AdaptSize(-38))
            make.width.equalTo(AdaptSize(32))
            make.height.equalTo(AdaptSize(14))
        }
        self.reviewLabel.snp.makeConstraints { (make) in
            make.right.equalTo(AdaptSize(-38))
            make.width.equalTo(AdaptSize(32))
            make.height.equalTo(AdaptSize(14))
            make.top.equalTo(self.snp.centerY)
        }
        
        self.learningProgressLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(learningLabel.snp.right).offset(AdaptSize(2))
            make.height.equalTo(AdaptSize(14))
        }
        
        self.reviewProgressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(reviewLabel.snp.right).offset(AdaptSize(2))
            make.right.equalToSuperview()
            make.height.equalTo(AdaptSize(14))
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func clickBackButton() {
        self.delegate?.clickHomeBtnEvent()
    }
    
    @objc func clickSwitchButton() {
        self.delegate?.clickSwitchBtnEvent()
    }
    
    @objc func clickSkipButton() {
        self.delegate?.clickSkipBtnEvent()
    }
    
}
