//
//  YXNotWordReviewView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 没有复习的单词弹框
class YXNotReviewWordView: YXTopWindowView {
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var doneButton = UIButton()
    
    
    deinit {
        doneButton.removeTarget(self, action: #selector(clickDoneButton), for: .touchUpInside)
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(doneButton)
    }
    
    
    override func bindProperty() {
        imageView.image = UIImage(named: "review_not_review_word")
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
        titleLabel.textColor = UIColor.black1
        titleLabel.text = "你太厉害了！"
        
        descLabel.font = UIFont.pfSCRegularFont(withSize: AS(14))
        descLabel.textColor = UIColor.black2
        descLabel.text = "暂时没有复习的单词，先学一些新词，明天再来试试吧～"
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = AS(20)
        doneButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        doneButton.setTitle("好的", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        doneButton.addTarget(self, action: #selector(clickDoneButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(267))
            make.height.equalTo(AS(303))
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(29))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(153))
            make.height.equalTo(AS(105))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(4))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(91))
            make.height.equalTo(AS(22))
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(33))
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.height.equalTo(AS(52))
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.height.equalTo(AS(40))
            make.bottom.equalTo(AS(-26))
        }
    
        
    }
    
    @objc func clickDoneButton() {
        self.removeFromSuperview()
    }

}
