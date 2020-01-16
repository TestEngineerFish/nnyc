//
//  YXReviewResultStarView.swift
//  YXEDU
//
//  Created by sunwu on 2020/1/16.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXReviewResultStarView: YXView {
    
    public var count: Int = 0 {
        didSet { bindData() }
    }
    
    private var imageView1 = UIImageView()
    private var imageView2 = UIImageView()
    private var imageView3 = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        self.addSubview(imageView1)
        self.addSubview(imageView2)
        self.addSubview(imageView3)
    }
    
    override func bindProperty() {
        imageView1.image = UIImage(named: "review_finish_result_star_gray")
        imageView2.image = UIImage(named: "review_finish_result_star_gray")
        imageView3.image = UIImage(named: "review_finish_result_star_gray")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView1.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.width.height.equalTo(AS(29))
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(AS(45))
        }
        
        imageView3.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.width.height.equalTo(AS(29))
        }
        
    }
        
    override func bindData() {
        if count >= 1 {
            imageView1.image = UIImage(named: "review_finish_result_star")
        }
        if count >= 2 {
            imageView2.image = UIImage(named: "review_finish_result_star")
        }
        if count >= 3 {
            imageView3.image = UIImage(named: "review_finish_result_star")
        }
    }
}

