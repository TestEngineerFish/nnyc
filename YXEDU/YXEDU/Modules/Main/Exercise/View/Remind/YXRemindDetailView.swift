//
//  YXRemindDetailView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/13.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXRemindDetailView: YXView {

    public  var word: YXWordModel
    private var contentView: UIView = UIView()
    private var studyButton = UIButton()
    private var wordDetailView: YXWordDetailCommonView
    
    init(word: YXWordModel) {
        self.word = word
        self.wordDetailView = YXWordDetailCommonView(frame: CGRect.zero, word: word)
        super.init(frame: CGRect.zero)
        
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(self.contentView)
        contentView.addSubview(self.wordDetailView)
        contentView.addSubview(self.studyButton)
    }
    
    override func bindProperty() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
        
        studyButton.setTitle("继续学习", for: .normal)
        studyButton.setTitleColor(UIColor.orange1, for: .normal)
        studyButton.setTitleColor(UIColor.white, for: .highlighted)
        studyButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 17)
        studyButton.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        studyButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .highlighted)
        studyButton.addTarget(self, action: #selector(clickStudyButton), for: .touchUpInside)
        studyButton.layer.borderColor = UIColor.orange1.cgColor
        studyButton.layer.borderWidth = 1
        studyButton.layer.masksToBounds = true
        studyButton.layer.cornerRadius = 21
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(35 + (iPhoneXLater ? 34 : 0))
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(6)
        }
        
        
        self.wordDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(41)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(studyButton.snp.top).offset(-20)
        }
        
        self.studyButton.snp.makeConstraints { (make) in
            make.left.equalTo(49)
            make.right.equalTo(-49)
            make.height.equalTo(42)
            make.bottom.equalTo(-6 - 19 - (iPhoneXLater ? 34 : 0))
        }
        
    }
    
    override func bindData() {
        
    }
    
    @objc func clickStudyButton() {
        self.removeFromSuperview()
    }
    
}
