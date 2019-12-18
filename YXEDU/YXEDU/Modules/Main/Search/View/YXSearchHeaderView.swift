//
//  YXSearchHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/18.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXSearchHeaderView: YXView {
            
    var searchTextFeild = UITextField()
    var cancelButton = UIButton()
    
    deinit {
        self.cancelButton.removeTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        searchTextFeild.removeTarget(self, action: #selector(didSearchTextFeildChanged), for: .editingChanged)
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
        self.addSubview(searchTextFeild)
        self.addSubview(cancelButton)
    }
    
    override func bindProperty() {
        self.backgroundColor = UIColor.gradientColor(with: CGSize(width: screenWidth, height: 86), colors: [UIColor.hex(0xFFC671), UIColor.hex(0xFFA83E)], direction: .leftTop)
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.regularFont(ofSize: 14)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        
        searchTextFeild.backgroundColor = UIColor.white
        searchTextFeild.layer.masksToBounds = true
        searchTextFeild.layer.cornerRadius = 17
        searchTextFeild.addTarget(self, action: #selector(didSearchTextFeildChanged), for: .editingChanged)
        searchTextFeild.placeholder = "请输入要查询的单词和中文"
        searchTextFeild.textColor = UIColor.black1
        searchTextFeild.font = UIFont.regularFont(ofSize: 15)
        searchTextFeild.clearButtonMode = .always
        searchTextFeild.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        searchTextFeild.leftViewMode = .always
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchTextFeild.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-71)
            make.height.equalTo(34)
            make.bottom.equalTo(-17)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(searchTextFeild)
            make.left.equalTo(searchTextFeild.snp.right).offset(5)
            make.right.equalTo(-5)
        }
    }
    
    
    @objc func clickCancelButton() {
        YRRouter.popViewController(true)
    }
    
    
    @objc func didSearchTextFeildChanged() {
        
    }
    
}
