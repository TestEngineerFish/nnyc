//
//  CALayer+YXCustom.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/7.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "CALayer+YXCustom.h"

@implementation CALayer (YXCustom)

/**
 * 爱的魔力转圈圈(无限旋转)
 **/
- (void)rotateView
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
