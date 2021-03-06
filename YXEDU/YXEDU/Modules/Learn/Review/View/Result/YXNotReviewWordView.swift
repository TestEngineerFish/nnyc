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
    
    var doneEvent: (() -> Void)?
    
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
        
        mainView.addSubview(imageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(descLabel)
        mainView.addSubview(doneButton)
    }
    
    
    override func bindProperty() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        imageView.image = UIImage(named: "review_not_review_word")
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(15))
        titleLabel.textColor = UIColor.black1
        titleLabel.text = "你太厉害了！"
        
        descLabel.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(14))
        descLabel.textColor = UIColor.black2
        descLabel.text = "暂时没有复习的单词，先学一些新词，明天再来试试吧～"
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0

        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = AdaptIconSize(20)
        doneButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        doneButton.setTitle("好的", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(17))
        doneButton.addTarget(self, action: #selector(clickDoneButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AdaptIconSize(267))
            make.height.equalTo(AdaptIconSize(303))
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(AdaptIconSize(29))
            make.centerX.equalToSuperview()
            make.width.equalTo(AdaptIconSize(153))
            make.height.equalTo(AdaptIconSize(105))
        }

        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AdaptIconSize(4))
            make.centerX.equalToSuperview()
            make.size.equalTo(titleLabel.size)
        }

        descLabel.sizeToFit()
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AdaptIconSize(33))
            make.left.equalTo(AdaptIconSize(22))
            make.right.equalTo(AdaptIconSize(-22))
            make.height.equalTo(AdaptIconSize(52))
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(AdaptIconSize(22))
            make.right.equalTo(AdaptIconSize(-22))
            make.height.equalTo(AdaptIconSize(40))
            make.bottom.equalTo(AdaptIconSize(-26))
        }
    
        
    }
    
    @objc func clickDoneButton() {
        self.doneEvent?()
        self.removeFromSuperview()
    }

}
