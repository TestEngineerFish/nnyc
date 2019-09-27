//
//  YXBeansAnimateView.m
//  YXEDU
//
//  Created by yao on 2019/1/15.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBeansAnimateView.h"
@interface YXBeansAnimateView ()<CAAnimationDelegate>
@property (nonatomic, assign) NSInteger beanCount;
@property (nonatomic, assign) CGPoint fromPoint;
@property (nonatomic, assign) CGPoint toPoint;
@property (nonatomic, copy) void(^finishBlock)(void);
@property (nonatomic, strong) NSMutableArray *beans;
@end

@implementation YXBeansAnimateView
+ (instancetype)showBeansAnimateViewWithBeanCount:(NSInteger)beanCount
                                        fromPoint:(CGPoint)fromPoint
                                          toPoint:(CGPoint)toPoint
                                      finishBlock:(void (^)(void))finishBlock
{
    YXBeansAnimateView *beansAnimateView = [[self alloc] initWithBeanCount:beanCount
                                                                 fromPoint:fromPoint
                                                                   toPoint:toPoint
                                                               finishBlock:finishBlock];
    beansAnimateView.frame = [UIScreen mainScreen].bounds;
    [UIApplication.sharedApplication.delegate.window addSubview:beansAnimateView];
    return beansAnimateView;
}


- (NSMutableArray *)beans {
    if (!_beans) {
        _beans = [NSMutableArray array];
    }
    return _beans;
}

- (instancetype)initWithBeanCount:(NSInteger)beanCount
                        fromPoint:(CGPoint)fromPoint
                          toPoint:(CGPoint)toPoint
                      finishBlock:(void(^)(void))finishBlock
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.beanCount = beanCount;
        self.fromPoint = fromPoint;
        self.toPoint = toPoint;
        self.finishBlock = [finishBlock copy];
        [self doFlyBeansAnimation];
    }
    return self;
}

- (void)doFlyBeansAnimation {
    [self.beans removeAllObjects];
    
    CGPoint startPoint = self.fromPoint;
    CGPoint targetPoint = self.toPoint;
    CGFloat midXStartEndPoint = (startPoint.x + targetPoint.x) * 0.5;
    CGFloat maxHeightReferStartPoint = 100;
    CGFloat controlPointMargin = (targetPoint.x - startPoint.x) * 0.25;
    CGPoint controlPoint1 = CGPointMake(midXStartEndPoint - controlPointMargin, startPoint.y - maxHeightReferStartPoint);
    CGPoint controlPoint2 = CGPointMake(midXStartEndPoint + controlPointMargin, startPoint.y - maxHeightReferStartPoint);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:targetPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.path = path.CGPath;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:4 * M_PI];
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.values = @[@1,@1.2,@0.2];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation, scaleAnimation, alphaAnimation];
    groups.duration = 0.6;
    //按照上面这样写，动画的removedOnCompletion属性默认为YES，运行一次动画就会销毁。结果就是动画结束的代理回调中使用
    //[bean.layer animationForKey:@"group"]为null,因此一定要加groups.removedOnCompletion=NO这句话
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    
    CFTimeInterval now = CACurrentMediaTime();
    for (NSInteger i = 0; i < self.beanCount; i++) {
        UIImageView *bean = [[UIImageView alloc] init];
        bean.image = [UIImage imageNamed:@"goldBeanImage"];
        bean.frame = CGRectMake(0, 0, 30, 30);
        bean.center = startPoint;
        groups.beginTime = now + 0.1 * i;
        [self addSubview:bean];
        [bean.layer addAnimation:groups forKey:@"group"];
        [self.beans addObject:bean];
    }
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    for (UIImageView *bean in self.beans) {
        if ([[bean.layer animationForKey:@"group"] isEqual:anim]) {
            [bean removeFromSuperview];
            [self.beans removeObject:bean];
            break;
        }
    }
    
    if (self.beans.count == 0) { 
        [self removeFromSuperview];
        if (self.finishBlock) {
            self.finishBlock();
        }
    }
}
@end
