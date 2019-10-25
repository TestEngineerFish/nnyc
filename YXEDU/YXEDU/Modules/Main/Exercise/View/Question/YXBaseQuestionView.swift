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
    
    /// 容器view
    var contentView: UIView = UIView()
    
    /// 主标题
    var titleLabel: UILabel?
    
    /// 子标题
    var subTitleLabel: UILabel?
    
    /// 扩展或者额外的标题（当连个标题都不够用的时候）
    var descTitleLabel: UILabel?
    
    /// 播放器
    var playerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createSubviews() {
        contentView.frame = CGRect(x: 22, y: 80, width: screenWidth - 22 * 2, height: 160)
        
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
    
    
    func initTitleLabel() {
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont(name: "苹方-简 中粗体", size: 20)
        self.titleLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.titleLabel?.text = "coffee"
        
        self.addSubview(titleLabel!)
    }
    
    
    func initSubTitleLabel() {
        self.subTitleLabel = UILabel()
        self.subTitleLabel?.font = UIFont(name: "苹方-简 常规体", size: 14)
        self.subTitleLabel?.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        self.subTitleLabel?.text = "[ˈkɔːfi]"
        
        self.addSubview(subTitleLabel!)
    }
    
    func initDescTitleLabel() {
        self.descTitleLabel = UILabel()
        self.descTitleLabel?.font = UIFont(name: "苹方-简 常规体", size: 14)
        self.descTitleLabel?.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        self.descTitleLabel?.text = "n.（名词）小船，艇"
        
        self.addSubview(descTitleLabel!)
    }

}
