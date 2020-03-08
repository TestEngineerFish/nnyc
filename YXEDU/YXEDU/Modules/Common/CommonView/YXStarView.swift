//
//  YXStarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXStarView: UIView {
    
    var leftStarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    var centerStarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    var rightStarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// 显示上一次新学结果视图
    func showLastNewLearnResultView(starNum: Int) {
        self.setStarStatus(starNum: starNum)
        self.addSubview(leftStarImageView)
        self.addSubview(centerStarImageView)
        self.addSubview(rightStarImageView)
        centerStarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(30)))
        }
        leftStarImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarImageView.snp.left).offset(AdaptSize(2))
            make.top.equalTo(centerStarImageView).offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        rightStarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarImageView.snp.right).offset(AdaptSize(-2))
            make.top.equalTo(leftStarImageView)
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
    }
    
    /// 显示结果页
    func showResultView(starNum: Int) {
        self.setStarStatus(starNum: starNum)
        self.addSubview(leftStarImageView)
        self.addSubview(centerStarImageView)
        self.addSubview(rightStarImageView)
        centerStarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        leftStarImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarImageView.snp.left).offset(AdaptSize(-5))
            make.centerY.equalTo(centerStarImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
        }
        rightStarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarImageView.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(centerStarImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31.5), height: AdaptSize(31.5)))
        }
    }
    
    // MARK: ---- Tools ----
    private func setStarStatus(starNum: Int) {
        if starNum > 0 {
            leftStarImageView.image = UIImage(named: "star_h_enable")
        } else {
            leftStarImageView.image = UIImage(named: "star_h_disable")
        }
        if starNum > 1 {
            centerStarImageView.image = UIImage(named: "star_h_enable")
        } else {
            centerStarImageView.image = UIImage(named: "star_h_disable")
        }
        if starNum > 2 {
            rightStarImageView.image = UIImage(named: "star_h_enable")
        } else {
            rightStarImageView.image = UIImage(named: "star_h_disable")
        }
    }
}
