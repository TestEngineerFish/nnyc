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
    private var iconButton: UIButton = UIButton()
    private var tipsButton: UIButton = UIButton()
    
    
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
        self.addSubview(iconButton)
        self.addSubview(tipsButton)
    }
    
    func bindProperty() {
        self.backgroundColor = UIColor.white
        
        self.iconButton.setBackgroundImage(UIImage(named: "exercise_tips"), for: .normal)
        self.iconButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)
    
        self.tipsButton.setTitle("提示一下", for: .normal)
        self.tipsButton.setTitleColor(UIColor.black3, for: .normal)
        self.tipsButton.setTitleColor(UIColor.black2, for: .highlighted)
        self.tipsButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 12)
        self.tipsButton.addTarget(self, action: #selector(clickTipsButton), for: .touchUpInside)

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.width.height.equalTo(18)
        }
        
        self.tipsButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconButton.snp.right).offset(1)
            make.width.equalTo(49)
            make.height.equalTo(17)
        }        
    }
    
    
    @objc func clickTipsButton() {
        self.tipsEvent?()
    }
    
}
