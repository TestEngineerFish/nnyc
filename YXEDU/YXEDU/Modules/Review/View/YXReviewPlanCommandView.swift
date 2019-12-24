//
//  YXReviewPlanCommandView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 复习计划口令页
class YXReviewPlanCommandView: YXTopWindowView {
    
    var detailEvent: (() -> ())?
    
    var iconImageView = UIImageView()
    var shareImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLable = UILabel()
    var descLabel = UILabel()
    
    var detailButton = UIButton()
    var closeButton = UIButton()
    
    var model: YXReviewPlanCommandModel? {
        didSet { bindData() }
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLable)
        contentView.addSubview(descLabel)
        contentView.addSubview(iconImageView)
        
        contentView.addSubview(shareImageView)
        contentView.addSubview(detailButton)
        contentView.addSubview(closeButton)
    }
    
    override func bindProperty() {        
        
        iconImageView.image = UIImage(named: "share_scan_book")
        shareImageView.image = UIImage(named: "share_scan_share")
        
        
        titleLabel.textColor = UIColor.black1
        titleLabel.font = UIFont.regularFont(ofSize: AS(15))
        
        subTitleLable.textColor = UIColor.black3
        subTitleLable.font = UIFont.regularFont(ofSize: AS(14))
        
//        descLabel.textColor = UIColor.black3
//        descLabel.font = UIFont.regularFont(ofSize: AS(14))
                
        
        detailButton.layer.masksToBounds = true
        detailButton.layer.cornerRadius = AS(20)
        detailButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        detailButton.setTitle("查看详情", for: .normal)
        detailButton.setTitleColor(UIColor.white, for: .normal)
        detailButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        detailButton.addTarget(self, action: #selector(clickDetailButton), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "share_scan_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AS(304))
            make.height.equalTo(AS(214))
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(33))
            make.left.equalTo(AS(85))
            make.width.equalTo(AS(38))
            make.height.equalTo(AS(40))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(33))
            make.left.equalTo(iconImageView.snp.right).offset(AS(17))
            make.right.equalTo(AS(-20))
            make.height.equalTo(AS(21))
        }
        
        subTitleLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(3))
            make.left.equalTo(iconImageView.snp.right).offset(AS(17))
            make.right.equalTo(AS(-20))
            make.height.equalTo(AS(20))
        }
        
        shareImageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(96))
            make.left.equalTo(AS(49))
            make.width.equalTo(AS(19))
            make.height.equalTo(AS(19))
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(98))
            make.left.equalTo(shareImageView.snp.right).offset(AS(49))
            make.right.equalTo(AS(-20))
            make.height.equalTo(AS(20))
        }
        
        detailButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(AS(26))
            make.left.equalTo(AS(40))
            make.right.equalTo(AS(-40))
            make.height.equalTo(AS(40))
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(AS(6))
            make.right.equalTo(AS(-6))
            make.width.equalTo(AS(22))
            make.height.equalTo(AS(22))
        }
        
    }
    
    override func bindData() {
        titleLabel.text = model?.planName
        subTitleLable.text = "共\(model?.wordCount ?? 0)个单词"
        descLabel.attributedText = attrString()
    }
    
    @objc func clickDetailButton() {
        self.detailEvent?()
    }
    
    
    @objc func clickCloseButton() {
        self.removeFromSuperview()
    }

    
    
    func attrString() -> NSAttributedString {
        
        let color1 = UIColor.hex(0xD5C5AB)
        let color2 = UIColor.hex(0xC1AB87)
        
        let attrString = NSMutableAttributedString(string: "来自 \(model?.nickname ?? "") 分享的复习计划")
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: color1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: color2]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: 3, length: model?.nickname?.count ?? 0))

        return attrString
    }
}
