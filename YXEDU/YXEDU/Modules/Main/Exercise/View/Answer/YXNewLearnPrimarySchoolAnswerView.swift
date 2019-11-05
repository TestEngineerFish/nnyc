//
//  YXNewLearnAnswerView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/4.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Lottie

class YXNewLearnAnswerView: YXBaseAnswerView, CAAnimationDelegate {

    var resultView: YXLearnResultAnimationSubview?
    var titleLabel: UILabel?
    var readView: AnimationView?
    let showRead   = "ShowReadAnimation"

    //MARK: TOOL
    /// 显示跟读动画
    func showReadAnaimtion() {
        self.readView = AnimationView(name: "readAnimation")
        self.addSubview(readView!)
        readView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(AdaptSize(52))
        })
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue      = 0
        scaleAnimation.toValue        = 1
        scaleAnimation.duration       = 0.5
        scaleAnimation.fillMode       = .forwards
        scaleAnimation.autoreverses   = false
        scaleAnimation.repeatCount    = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.setValue(true, forKey: showRead)
        scaleAnimation.delegate = self


        self.titleLabel = UILabel()
        self.titleLabel?.text = "请跟读"
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: AdaptSize(13))
        self.titleLabel?.textColor = UIColor.black6
        self.titleLabel?.textAlignment = .center
        self.addSubview(titleLabel!)
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(readView!.snp.top).offset(AdaptSize(-8))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(15))
        })
        readView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
        self.readView?.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.titleLabel?.text = "打分中……"
        }
    }

    /// 隐藏跟读动画
    private func hideReadAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue      = 1
        scaleAnimation.toValue        = 0
        scaleAnimation.duration       = 0.5
        scaleAnimation.fillMode       = .forwards
        scaleAnimation.autoreverses   = false
        scaleAnimation.repeatCount    = 1
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.setValue(false, forKey: showRead)
        scaleAnimation.delegate = self
        self.readView?.layer.add(scaleAnimation, forKey: nil)
        titleLabel?.layer.add(scaleAnimation, forKey: nil)
        // 移除视图
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.titleLabel?.removeFromSuperview()
            self.readView?.removeFromSuperview()
            self.titleLabel = nil
            self.readView   = nil
        }
    }

    /// 显示结果动画
    private func showResultAnimation(_ score: Int) {
        resultView = YXLearnResultAnimationSubview(score)
        self.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
            make.height.equalTo(AdaptSize(85))
        })
        resultView?.animationComplete = {
            print("add complete")
            self.delegate?.playAudio()
        }
        resultView?.showAnimation()

    }

    /// 隐藏结果动画
    private func hideResultAnimation() {
        resultView?.hideAnimation()
        resultView = nil
    }

    override func endPlayAudio() {
        super.endPlayAudio()
        self.showReadAnaimtion()
    }

    // MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let showRead = anim.value(forKey: showRead) as? Bool {
            if showRead {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                    self.hideReadAnimation()
                }
            } else {
                self.showResultAnimation(Int(arc4random()%3 + 1))
            }
        } 
    }
}
