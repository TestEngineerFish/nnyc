//
//  YXExerciseBottomView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/28.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习模块：底部View
class YXExerciseBottomView: UIView {
    
    var tipsEvent: (() -> Void)?
    
    //MARK: - 私有属性
    private var tipsButton = UIButton()
    private var skipButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red

        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSubviews() {
        self.addSubview(tipsButton)
        self.addSubview(skipButton)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        self.tipsButton.setTitle("提示一下", for: .normal)
        self.tipsButton.setImage(UIImage(named: "exercise_tips"), for: .normal)
        self.tipsButton.setTitleColor(UIColor.black3, for: .normal)
        self.tipsButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.tipsButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 12)
        self.tipsButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)

        self.skipButton.setTitle("太简单了", for: .normal)
        self.skipButton.setTitleColor(UIColor.black3, for: .normal)
        self.skipButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.skipButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)
        self.skipButton.layer.borderColor  = UIColor.black6.cgColor
        self.skipButton.layer.borderWidth  = 0.5
        self.skipButton.layer.cornerRadius = 13
    }

    func showSkipButton() {
        self.tipsButton.isHidden = true
        self.skipButton.isHidden = true
        self.skipButton.layer.borderColor  = UIColor.black6.cgColor
        self.skipButton.layer.borderWidth  = 0.5
        self.skipButton.layer.cornerRadius = 13
        self.skipButton.setTitle("太简单了", for: .normal)
    }

    func showTipsButton() {
        self.skipButton.isHidden = true
        self.tipsButton.isHidden = false
        self.tipsButton.layer.borderColor  = UIColor.black6.cgColor
        self.tipsButton.layer.borderWidth  = 0.5
        self.tipsButton.layer.cornerRadius = 13
        self.tipsButton.setTitle("太简单了", for: .normal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tipsButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.width.equalTo(100)
            make.height.equalTo(17)
        }
        self.skipButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.width.equalTo(100)
            make.height.equalTo(17)
        }
    }
    
    
    @objc func clickTipsButton() {
        self.tipsEvent?()
    }
    
}
