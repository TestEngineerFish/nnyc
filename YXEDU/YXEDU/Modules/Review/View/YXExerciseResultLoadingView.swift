//
//  YXExerciseResultLoadingView.swift
//  YXEDU
//
//  Created by sunwu on 2020/2/11.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXExerciseResultLoadingView: YXView {
    
    var clickEvent: (() -> Void)?
    var titleLabel = UILabel()
    var imageView = UIImageView()
    
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
        self.addSubview(imageView)
    }
    
    override func bindProperty() {
        imageView.image = UIImage(named: "")
        imageView.backgroundColor = UIColor.orange1
        
        titleLabel.text = "正在生成报告…"
        titleLabel.font = UIFont.regularFont(ofSize: 13)
        titleLabel.textColor = UIColor.black3
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(AS(80))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(19))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(92))
            make.height.equalTo(AS(18))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.clickEvent?()
    }
}
