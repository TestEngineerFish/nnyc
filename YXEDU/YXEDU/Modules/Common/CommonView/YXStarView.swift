//
//  YXStarView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

enum YXStarType: Int {
    case lastLearnResult = 0 //上次学习结果
    case newLearnResult  = 1 // 新学结果
    case learnResult     = 2 // 学习流程结果
}

class YXStarView: UIView {
    
    var leftStarDisableImageView   = UIImageView()
    var leftStarEnableImageView    = UIImageView()
    var centerStarDisableImageView = UIImageView()
    var centerStarEnableImageView  = UIImageView()
    var rightStarDisableImageView  = UIImageView()
    var rightStarEnableImageView   = UIImageView()
    
    var starNumber = 0
    
    /// 上次学习结果
    func showLastNewLearnResultView(score: Int) {
        self.starNumber = {
            if score > YXStarLevelEnum.three.rawValue {
                return 3
            } else if score > YXStarLevelEnum.two.rawValue {
                return 2
            } else if score > YXStarLevelEnum.one.rawValue {
                return 1
            } else if score >= YXStarLevelEnum.zero.rawValue {
                return 0
            } else {
                return -1
            }
        }()
        self.setImage(.lastLearnResult)
        self.setStarStatus()
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(30), height: AdaptSize(30)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.top.equalTo(centerStarDisableImageView).offset(AdaptSize(13))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.top.equalTo(leftStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 新学结果页
    func showNewLearnResultView(starNum: Int) {
        self.starNumber = starNum
        self.resetStatus()
        self.setImage(.learnResult)
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.showAnimation()
    }
    
    /// 显示流程学习结果
    func showLearnResultView(starNum: Int) {
        self.starNumber = starNum
        self.resetStatus()
        self.setImage(.learnResult)
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(45)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left).offset(AdaptSize(2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right).offset(AdaptSize(-2))
            make.centerY.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(31), height: AdaptSize(31)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.showAnimation()
    }

    /// 显示其他同学词单学习情况
    func showStudentResultView(starNum: Int) {
        self.starNumber = starNum
        self.setImage(.lastLearnResult)
        self.setStarStatus()
        self.addSubview(leftStarDisableImageView)
        self.addSubview(centerStarDisableImageView)
        self.addSubview(rightStarDisableImageView)
        self.leftStarDisableImageView.addSubview(leftStarEnableImageView)
        self.centerStarDisableImageView.addSubview(centerStarEnableImageView)
        self.rightStarDisableImageView.addSubview(rightStarEnableImageView)

        centerStarDisableImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(21), height: AdaptSize(21)))
        }
        leftStarDisableImageView.snp.makeConstraints { (make) in
            make.right.equalTo(centerStarDisableImageView.snp.left)
            make.top.equalTo(centerStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(21), height: AdaptSize(21)))
        }
        rightStarDisableImageView.snp.makeConstraints { (make) in
            make.left.equalTo(centerStarDisableImageView.snp.right)
            make.top.equalTo(leftStarDisableImageView)
            make.size.equalTo(CGSize(width: AdaptSize(21), height: AdaptSize(21)))
        }
        centerStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        rightStarEnableImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: ---- Tools ----
    private func setStarStatus() {
        leftStarDisableImageView.isHidden   = self.starNumber < 0
        centerStarDisableImageView.isHidden = self.starNumber < 0
        rightStarDisableImageView.isHidden  = self.starNumber < 0
        leftStarEnableImageView.isHidden    = self.starNumber < 1
        centerStarEnableImageView.isHidden  = self.starNumber < 2
        rightStarEnableImageView.isHidden   = self.starNumber < 3
    }
    
    private func setImage(_ type: YXStarType) {
        let enabelImage: UIImage? = {
            switch type {
            case .lastLearnResult:
                return UIImage(named: "star_new_enable")
            case .learnResult, .newLearnResult:
                return UIImage(named: "star_h_enable")
            }
        }()
        let disableImage: UIImage? = {
            switch type {
            case .lastLearnResult:
                return UIImage(named: "star_new_disable")
            case .learnResult, .newLearnResult:
                return UIImage(named: "star_h_disable")
            }
        }()
        self.leftStarEnableImageView.image    = enabelImage
        self.leftStarDisableImageView.image   = disableImage
        self.centerStarEnableImageView.image  = enabelImage
        self.centerStarDisableImageView.image = disableImage
        self.rightStarEnableImageView.image   = enabelImage
        self.rightStarDisableImageView.image  = disableImage
    }
    
    private func resetStatus() {
        self.leftStarEnableImageView.isHidden   = true
        self.centerStarEnableImageView.isHidden = true
        self.rightStarEnableImageView.isHidden  = true
    }
    
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values         = [0, 1.1, 1.0]
        animation.duration       = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        if self.starNumber > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.leftStarEnableImageView.isHidden = false
                self.leftStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar1()
            }
        }
        if self.starNumber > 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.centerStarEnableImageView.isHidden = false
                self.centerStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar2()
            }
        }
        if self.starNumber > 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.rightStarEnableImageView.isHidden = false
                self.rightStarEnableImageView.layer.add(animation, forKey: nil)
                YXAVPlayerManager.share.playStar3()
            }
        }
    }
}
