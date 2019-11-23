//
//  YXExerciseAnimation.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/1.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXExerciseAnimation {
    ///  显示放大渐隐动画
    static func zoomInHideAnimation() -> CAAnimationGroup {
        let zoomInAnimation = CABasicAnimation(keyPath: "transform")
        zoomInAnimation.fromValue = CATransform3DMakeScale(1, 1, 1)
        zoomInAnimation.toValue   = CATransform3DMakeScale(2, 2, 1)

        let hideAnimation = CABasicAnimation(keyPath: "opacity")
        hideAnimation.fromValue = 1
        hideAnimation.toValue   = 0

        let zoomInHideAnimation = CAAnimationGroup()
        zoomInHideAnimation.animations = [zoomInAnimation, hideAnimation]
        zoomInHideAnimation.duration = 1.2
        zoomInHideAnimation.isRemovedOnCompletion = false
        zoomInHideAnimation.repeatCount = 1
        zoomInHideAnimation.fillMode = .forwards
        zoomInHideAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return zoomInHideAnimation
    }
}
