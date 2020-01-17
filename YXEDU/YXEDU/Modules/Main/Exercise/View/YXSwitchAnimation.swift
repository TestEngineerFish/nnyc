//
//  YXSwitchExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/22.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie


/// 练习题切换，显示的动画
class YXSwitchAnimation: NSObject, CAAnimationDelegate {

    public var animationDidStop: ((_ isRight: Bool) -> Void)?
    public var owenrView: UIView?
    
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
    
    /// 显示正确动画
    private func showRightAnimation() {
        let resultView = AnimationView(name: "right")
        kWindow.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(180), height: AdaptSize(180)))
        }
        self.owenrView?.isUserInteractionEnabled = false
        resultView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            resultView.removeFromSuperview()
            self.owenrView?.isUserInteractionEnabled = true
            self.animationDidStop?(true)
        }
    }

    /// 显示错误动画
    private func showWrongAnimation() {
//        let resultView = AnimationView(name: "wrong")
//        kWindow.addSubview(resultView)
//        resultView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: AdaptSize(180), height: AdaptSize(180)))
//        }
        self.owenrView?.isUserInteractionEnabled = false
//        resultView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
//            resultView.removeFromSuperview()
            self.owenrView?.isUserInteractionEnabled = true
            self.animationDidStop?(false)
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
