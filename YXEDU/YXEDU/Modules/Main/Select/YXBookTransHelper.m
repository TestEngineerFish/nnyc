//
//  YXBookTransHelper.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookTransHelper.h"

@interface YXBookTransHelper ()

@end

@implementation YXBookTransHelper

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    YXBookTransModel *transModel = self.transModel;
    CGSize iconSize = transModel.originRect.size;
    CGFloat x = (SCREEN_WIDTH - iconSize.width) * 0.5;
    CGFloat y = iPhone5 ? kNavHeight : kNavHeight + 16;
    transModel.destionationRect = CGRectMake(x, y, iconSize.width, iconSize.height);
    YXBookTransAnimator *animator = [[YXBookTransAnimator alloc] initWithAnimateType:self.animateType];
    animator.transModel = transModel;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    YXBookTransAnimator *animator = [[YXBookTransAnimator alloc] initWithAnimateType:self.animateType];
    animator.transModel = self.transModel;
    return animator;
}
@end

