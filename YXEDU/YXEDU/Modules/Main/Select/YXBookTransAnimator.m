//
//  YXBookTransAnimator.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookTransAnimator.h"

@implementation YXBookTransModel

@end





@interface YXBookTransAnimator () <CAAnimationDelegate>
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign)YXTransAnimateType animateType;
/** 最终位置 */
@property (nonatomic, assign) CGRect finalRect;
@property (nonatomic, weak) UIImageView *bookIcon;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YXBookTransAnimator
- (instancetype)initWithAnimateType:(YXTransAnimateType)animateType {
    if (self = [super init]) {
        self.animateType = animateType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    if (self.animateType == YXTransAnimatePresent) {
        [self presentAnimateTransition:transitionContext];
    }else {
        [self popAnimateTransition:transitionContext];
    }
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:toVC.view];
    [containerView addSubview:self.backgroundView];
    
    self.backgroundView.alpha = 0;
    toVC.view.hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.view.hidden = NO;
    }];

    self.imageView.frame = self.transModel.originRect;
    [containerView addSubview:self.imageView];
    
    UIImageView *imageView = self.imageView;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.frame = self.transModel.destionationRect;
            imageView.transform = CGAffineTransformScale(imageView.transform, 1.1, 1.1); // 注意形变叠加
            self.finalRect = imageView.frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                imageView.frame = self.transModel.destionationRect;
//                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
//                [imageView removeFromSuperview];
                [containerView insertSubview:toVC.view belowSubview:self.backgroundView];
                [self addPathAnimateWithView:self.backgroundView];
                [containerView bringSubviewToFront:imageView];
            }];
        }];
    }];
}

- (void)popAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIImageView *imageView = [containerView viewWithTag:10001];
    UIView *backgroundView = [containerView viewWithTag:10000];
    backgroundView.hidden = NO;
    CGPoint fromPoint = imageView.center;
    CGFloat X = SCREEN_WIDTH - fromPoint.x;
    CGFloat Y = SCREEN_HEIGHT - fromPoint.y;
    CGFloat radius = sqrt(X*X + Y*Y);
    
    UIBezierPath *origionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIBezierPath *origionCircle = [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(fromPoint.x, fromPoint.y, 0, 0), -radius, -radius)] bezierPathByReversingPath];
    [origionPath appendPath:origionCircle];
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIBezierPath *finalCircle = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(fromPoint.x, fromPoint.y, 0, 0)] bezierPathByReversingPath];
    [finalPath appendPath:finalCircle];

    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = origionPath.CGPath;
    backgroundView.layer.mask = layer;

    CABasicAnimation* animimation = [CABasicAnimation animationWithKeyPath:@"path"];
    animimation.fromValue = (__bridge id _Nullable)(origionPath.CGPath);
    animimation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animimation.delegate = self;
    animimation.duration = 0.4;
    animimation.removedOnCompletion = NO;
    animimation.fillMode = kCAFillModeForwards;
    animimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animimation.repeatCount = 1.0;
    [layer addAnimation:animimation forKey:@"path"];
}

- (void)addPathAnimateWithView:(UIView *)toView {
//    CGPoint point = CGPointMake(20, 150);
    CGPoint fromPoint = self.imageView.center;
    UIBezierPath *origionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIBezierPath *origionCircle = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(fromPoint.x, fromPoint.y, 0, 0)] bezierPathByReversingPath];
    [origionPath appendPath:origionCircle];

    CGFloat X = SCREEN_WIDTH - fromPoint.x;
    CGFloat Y = SCREEN_HEIGHT - fromPoint.y;
    CGFloat radius = sqrt(X*X + Y*Y);
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIBezierPath *finalCircle = [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(fromPoint.x, fromPoint.y, 0, 0), -radius, -radius)] bezierPathByReversingPath];
    [finalPath appendPath:finalCircle];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = finalPath.CGPath;
    toView.layer.mask = layer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id _Nullable)(origionPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 0.4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer addAnimation:animation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animateType == YXTransAnimatePop) {
        UIView *containerView = [self.transitionContext containerView];
//        [containerView bringSubviewToFront:self.imageView];
        UIImageView *imageView = [containerView viewWithTag:10001];
        UIView *backgroundView = [containerView viewWithTag:10000];
        
        UIViewController *fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        imageView.frame = self.transModel.destionationRect;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformScale(imageView.transform,1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                imageView.frame = self.transModel.originRect;
                imageView.transform = CGAffineTransformScale(imageView.transform, 1.1, 1.1);
//                self.finalRect = imageView.frame;
            } completion:^(BOOL finished) {
                [fromVC.view removeFromSuperview];
                [containerView sendSubviewToBack:toVC.view];
                [UIView animateWithDuration:0.4 animations:^{
                    imageView.frame = self.transModel.originRect;
                    backgroundView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                    [backgroundView removeFromSuperview];
                    [self.transitionContext completeTransition:YES];
                }];
            }];
        }];
        
        
    }else {
        self.backgroundView.hidden = YES;
//        [self.imageView removeFromSuperview];
//        self.backgroundView.layer.mask = nil;
//        [self.backgroundView removeFromSuperview];
//        [self.imageView removeFromSuperview];
        [self.transitionContext completeTransition:YES];
    }
}
#pragma mark - bgView
- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backgroundView.tag = 10000;
        backgroundView.backgroundColor = [UIColor mRGBColor:209 :208 :208];//UIColorOfHex(0xF3F8FE);
         CGFloat showHeight = iPhone5 ? 322 : 352;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - showHeight - kSafeBottomMargin, SCREEN_WIDTH, 420)];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.cornerRadius = 8.0;
        bottomView.layer.borderWidth = 0.5;
        bottomView.layer.borderColor = [UIColor whiteColor].CGColor;
        [backgroundView addSubview:bottomView];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 10001;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.transModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imageView.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 0);
        imageView.layer.shadowOpacity = 5;
        imageView.layer.shadowRadius = 2;
        imageView.layer.shadowOpacity = 0.6;
        _imageView = imageView;
    }
    return _imageView;
}

//- (UIView *)backgroundView {
//    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    backgroundView.backgroundColor = UIColorOfHex(0xF3F8FE);
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 352 - kSafeBottomMargin, SCREEN_WIDTH, 420)];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    bottomView.layer.cornerRadius = 5.0;
//
//    [backgroundView addSubview:bottomView];
//
//    return backgroundView;
//}
@end
