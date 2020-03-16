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
    
    var model: YXReviewPlanCommandModel?
    
    init(model: YXReviewPlanCommandModel) {
        super.init(frame: .zero)
        self.model = model
        self.bindData()
        self.createSubviews()
        self.bindProperty()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func createSubviews() {
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(subTitleLable)
        mainView.addSubview(descLabel)
        mainView.addSubview(iconImageView)
        
        mainView.addSubview(shareImageView)
        mainView.addSubview(detailButton)
        mainView.addSubview(closeButton)
    }
    
    override func bindProperty() {        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        iconImageView.image = UIImage(named: "share_scan_book")
        shareImageView.image = UIImage(named: "share_scan_share")
        
        
        titleLabel.textColor = UIColor.black1
        titleLabel.font = UIFont.regularFont(ofSize: AS(15))
        
        subTitleLable.textColor = UIColor.black3
        subTitleLable.font = UIFont.regularFont(ofSize: AS(14))
        
        descLabel.textColor = UIColor.black3
        descLabel.font = UIFont.regularFont(ofSize: AS(14))
                
        
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
        
        mainView.snp.makeConstraints { (make) in
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
            make.top.equalTo(AS(98.5))
            make.width.equalTo(AS(19))
            make.height.equalTo(AS(19))
        }
        
        var descWidth = descLabel.attributedText?.string.textWidth(font: descLabel.font, height: AS(20)) ?? 0
        let descMax: CGFloat = AS(304 - 26 - 40)
        descWidth = descWidth > descMax ? descMax : descWidth
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(98))
            
            let right = (AS(304) - descWidth - AS(26)) / 2
            make.left.equalTo(shareImageView.snp.right).offset(AS(7))
            make.right.equalTo(AS(-right))
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
        
        let attrString = NSMutableAttributedString(string: "来自 \(model?.nickname ?? "") 分享的\(YXReviewDataManager.reviewPlanName)")
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: color1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: color2]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: 3, length: model?.nickname?.count ?? 0))

        return attrString
    }
}
