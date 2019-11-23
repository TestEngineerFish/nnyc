//
//  YXSwitchExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习题切换，显示的动画
class YXSwitchAnimation: NSObject, CAAnimationDelegate {

    public var animationDidStop: ((_ isRight: Bool) -> Void)?
    public var owenrView: UIView?
    
    private let isRightKey = "Is_Right_Key"
    private var resultView = UIImageView()
    
    deinit {
        self.resultView.removeAllSubviews()
    }
    
    override init() {
        super.init()
        self.createSubviews()
    }
    
    public func show(isRight: Bool) {
        if isRight {
            showRightAnimation()
            YXAVPlayerManager.share.playRightAudio()
        } else {
            showWrongAnimation()
            YXAVPlayerManager.share.playWrongAudio()
        }
        feedback()
    }
    
    
    private func createSubviews() {
        self.resultView.isHidden = true
        
        kWindow.addSubview(resultView)
        self.resultView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
    }
    
    /// 显示正确动画
    private func showRightAnimation() {
        self.owenrView?.isUserInteractionEnabled = false
        self.resultView.isHidden = false
        self.resultView.image = UIImage(named: "success")
        let animation = YXExerciseAnimation.zoomInHideAnimation()
        animation.delegate = self
        animation.setValue(true, forKey: isRightKey)
        self.resultView.layer.add(animation, forKey: nil)
    }

    /// 显示错误动画
    private func showWrongAnimation() {
        self.owenrView?.isUserInteractionEnabled = false
        self.resultView.isHidden = false
        self.resultView.image = UIImage(named: "error")
        let animation = YXExerciseAnimation.zoomInHideAnimation()
        animation.delegate = self
        animation.setValue(false, forKey: isRightKey)
        self.resultView.layer.add(animation, forKey: nil)
    }
    
    
    // TODO: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.resultView.isHidden = true
        self.owenrView?.isUserInteractionEnabled = true
        self.resultView.layer.removeAllAnimations()
        if let isRight = anim.value(forKey: isRightKey) as? Bool {
            self.animationDidStop?(isRight)
        }
    }
    
    
    /// 震动效果
    func feedback() {
        if #available(iOS 10.0, *) {
            let shock = UIImpactFeedbackGenerator(style: .medium)
            shock.impactOccurred()
        }
    }
    
}
