//
//  YXExerciseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 问题面板基类
class YXBaseQuestionView: UIView {
    
    var exerciseModel: YXWordExerciseModel? {
        didSet { bindData() }
    }
    
    /// 容器view
    var contentView: UIView = UIView()
    
    /// 主标题
    var titleLabel: UILabel?
    
    /// 子标题
    var subTitleLabel: UILabel?
    
    /// 扩展或者额外的标题（当连个标题都不够用的时候）
    var descTitleLabel: UILabel?
    
    
    var imageView: UIImageView?
    
    /// 播放器
    var playerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
//        self.setShadowColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createSubviews() {
        contentView.frame = CGRect(x: 22, y: 0, width: screenWidth - 22 * 2, height: 160)
        
        // fillCode
        let bgLayer1 = CALayer()
        bgLayer1.frame = contentView.bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        contentView.layer.addSublayer(bgLayer1)
        
        // shadowCode
        contentView.layer.shadowColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 0.5).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 10
        
        self.addSubview(contentView)
    }
    
    func setShadowColor() {

    }
    
    func initTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: 20)
        self.titleLabel?.textColor = UIColor.black1
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.text = "coffee"
        
        contentView.addSubview(titleLabel!)
    }
    
    
    func initSubTitleLabel() {
        self.subTitleLabel = UILabel()
        self.subTitleLabel?.font = UIFont.pfSCRegularFont(withSize: 14)
        self.subTitleLabel?.textColor = UIColor.black2
        self.subTitleLabel?.textAlignment = .center
        self.subTitleLabel?.text = "[ˈkɔːfi]"
        
        contentView.addSubview(subTitleLabel!)
    }
    
    func initDescTitleLabel() {
        self.descTitleLabel = UILabel()
        self.descTitleLabel?.font = UIFont.pfSCRegularFont(withSize: 14)
        self.descTitleLabel?.textColor = UIColor.black2
        self.descTitleLabel?.textAlignment = .center
        self.descTitleLabel?.text = "n.（名词）小船，艇"
        
        contentView.addSubview(descTitleLabel!)
    }

    func initImageView() {
        self.imageView = UIImageView()
        self.imageView?.layer.masksToBounds = true
        self.imageView?.layer.cornerRadius = 6
        self.imageView?.backgroundColor = UIColor.orange1
        
        contentView.addSubview(imageView!)
    }
    
    func bindData()  {}
}
