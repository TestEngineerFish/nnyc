//
//  YRLoadingView.m
//  pyyx
//
//  Created by Chunlin Ma on 2017/3/22.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import "YRLoadingView.h"

@interface YRLoadingView ()

@property (readwrite, nonatomic) BOOL isAnimating;

- (void)setupDefaults;

- (void)drawCircles;

- (void)removeCircles;

- (void)adjustFrame;

- (UIView *)createCircleWithRadius:(CGFloat)radius color:(UIColor *)color;

- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay;

@end

@implementation YRLoadingView

#pragma mark - Initializations

+ (instancetype)loadingView {
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    return [self loadingForView:topWindow];
}

+ (instancetype)loadingForView:(UIView *)view {
    YRLoadingView *loadingView = [[YRLoadingView alloc] init];
    loadingView.center = CGPointMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5);
    [view addSubview:loadingView];
    [loadingView startAnimating];
    return loadingView;
}

+ (void)hideLoadingViewOnView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YRLoadingView class]]) {
            [obj removeFromSuperview];
            obj = nil;
            *stop = YES;
        }
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupDefaults
{
    self.bounceColor = [UIColor colorWithRed:137/255.0 green:180/255.0 blue:152/255.0 alpha:0.2];
    self.radius = 13.0f;
    self.delay = 1.0f;
    self.duration = 1.0f;
}

- (UIView *)createCircleWithRadius:(CGFloat)radius color:(UIColor *)color
{
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.radius*2, self.radius*2)];
    circle.backgroundColor = self.bounceColor;
    circle.layer.cornerRadius = self.radius;
    return circle;
}

- (CABasicAnimation *)createAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    anim.autoreverses = YES;
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime()+delay;
    anim.removedOnCompletion = NO;
    anim.repeatCount = INFINITY;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return anim;
}

- (void)drawCircles
{
    for (NSInteger i =0; i < 2; i++) {
        UIView *circle = [self createCircleWithRadius:self.radius color:self.bounceColor];
        [circle setTransform:CGAffineTransformMakeScale(0, 0)];
        [circle.layer addAnimation:[self createAnimationWithDuration:self.duration delay:(self.delay*i)] forKey:@"scale"];
        [self addSubview:circle];
    }
}

- (void)removeCircles
{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [[view layer] removeAllAnimations];
        [view removeFromSuperview];
    }];
}

- (void)adjustFrame
{
    CGRect frame = self.frame;
    frame.size.width = self.radius * 2;
    frame.size.height = self.radius * 2;
    self.frame = frame;
}
#pragma mark - Public Methods
- (void)startAnimating
{
    if (!self.isAnimating) {
        [self drawCircles];
        self.hidden = NO;
        self.isAnimating = YES;
    }
}

- (void)stopAnimating
{
    if (self.isAnimating) {
        [self removeCircles];
        self.hidden = YES;
        self.isAnimating = NO;
    }
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self adjustFrame];
}

@end
