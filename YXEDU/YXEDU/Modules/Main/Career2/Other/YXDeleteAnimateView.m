
//
//  YXDeleteAnimateView.m
//  YXEDU
//
//  Created by yao on 2018/12/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDeleteAnimateView.h"
@interface YXDeleteAnimateView ()<CAAnimationDelegate>
@property (nonatomic, strong)NSMutableArray *bubbles;
@property (nonatomic, copy)void (^completionBlock)(void);
@end

@implementation YXDeleteAnimateView
{
    UIView *_animateContentView;
    UIView *_animateView;
}

- (NSMutableArray *)bubbles {
    if (!_bubbles) {
        _bubbles = [NSMutableArray array];
    }
    return _bubbles;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self animateContentView];
        [self animateView];
    }
    return self;
}


- (UIView *)animateContentView {
    if (!_animateContentView) {
        UIView *animateContentView = [[UIView alloc] init];
        animateContentView.backgroundColor = [UIColor clearColor];
        animateContentView.layer.masksToBounds = YES;
        [self addSubview:animateContentView];
        _animateContentView = animateContentView;
    }
    return _animateContentView;
}

- (UIView *)animateView {
    if (!_animateView) {
        UIView *animateView = [[UIView alloc] init];
        animateView.backgroundColor = UIColorOfHex(0xFC7D8B);
        [self.animateContentView addSubview:animateView];
        _animateView = animateView;
    }
    return _animateView;
}

- (instancetype)initWithContentFrame:(CGRect)contentFrame {
    if (self = [super init]) {
        self.contentFrame = contentFrame;
    }
    return self;
}

- (void)setContentFrame:(CGRect)contentFrame {
    _contentFrame = contentFrame;
    self.animateContentView.frame = contentFrame;
    [self setupBubbles];
}
- (void)setupBubbles {
    CGFloat insertValue = 14;
    CGRect contectBounds = self.animateContentView.bounds;
    self.animateView.frame = CGRectOffset(contectBounds, contectBounds.size.width, 0);
    
    CGRect rangeRect = CGRectInset(self.animateContentView.bounds, insertValue, insertValue);
    CGFloat randomMinX = CGRectGetMinX(rangeRect);
    CGFloat randomMinY = CGRectGetMinY(rangeRect);
    CGFloat randomMaxY = CGRectGetMaxY(rangeRect);
    
    UIColor *bgColor = UIColorOfHex(0xFC7D8B);
    NSInteger count = 4;
    CGFloat maxRadius = insertValue;
    CGFloat minRadius = insertValue - 2;
    
    CGFloat margin = rangeRect.size.width / (count - 1);

    for (NSInteger i = 0; i < count; i ++) {
        CALayer *layer1 = [CALayer layer];
        layer1.hidden = YES;
        layer1.backgroundColor = bgColor.CGColor;
        [self.animateContentView.layer addSublayer:layer1];
        [self.bubbles addObject:layer1];
    
        CGFloat radius = i % 2 ? maxRadius : minRadius;
        CGFloat x = randomMinX + i * margin - radius;
        layer1.cornerRadius = radius;
        CGRect bubbleFrame = CGRectMake(x, randomMinY - radius, 2 * radius,  2 * radius);
        layer1.frame = bubbleFrame;
    }
    
    for (NSInteger i = 0 ; i < count - 1; i++) {
        CALayer *layer1 = [CALayer layer];
        layer1.hidden = YES;
        layer1.backgroundColor = bgColor.CGColor;
        [self.animateContentView.layer addSublayer:layer1];
        [self.bubbles addObject:layer1];
        
        CGFloat radius =  2 * maxRadius;
        CGFloat x = (randomMinX +  margin * 0.5) + i * margin - radius;
        
        layer1.cornerRadius = radius;
        CGRect bubbleFrame = CGRectMake(x, randomMinY, 2 * radius,  2 * radius);
        layer1.frame = bubbleFrame;
    }
    
    for (NSInteger i = 0; i < count; i ++) {
        CALayer *layer2 = [CALayer layer];
        layer2.hidden = YES;
        layer2.backgroundColor = bgColor.CGColor;
        [self.animateContentView.layer addSublayer:layer2];
        [self.bubbles addObject:layer2];
        CGFloat radius = i % 2 ? minRadius : maxRadius;
        layer2.cornerRadius = radius;
        CGFloat x = randomMinX + i * margin - radius;
        layer2.frame = CGRectMake(x, randomMaxY - radius, 2 * radius,  2 * radius);
    }
}

+ (YXDeleteAnimateView *)showDeleteAnimateViewWithContentFrame:(CGRect)contentFrame {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    YXDeleteAnimateView *screenView = [[self alloc] initWithContentFrame:contentFrame];
    screenView.frame = [UIScreen mainScreen].bounds;
    [window addSubview:screenView];
    return screenView;
}

- (void)doAnimationWithCompletion:(void (^)(void))completion {
    self.completionBlock = [completion copy];
    self.animateView.frame = self.animateContentView.bounds;
    self.animateContentView.backgroundColor = [UIColor whiteColor];
    for (CALayer * layer in self.bubbles) {
        layer.hidden = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.animateView.alpha = 0.0;
    }];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate  = self;
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *animateAlpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateAlpha.fromValue = @1;
    animateAlpha.toValue = @0.0;

    CABasicAnimation *animateScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animateScale.fromValue = @1;
    animateScale.toValue = @0.0;


    group.animations = @[animateAlpha,animateScale];
    CFTimeInterval now = CACurrentMediaTime();
    NSInteger count = self.bubbles.count;
    for (NSInteger i = 0; i < count; i++) {
        CALayer *layer = [self.bubbles objectAtIndex:i];
        CGFloat mode = i % 3;
        CGFloat offset = 0.1;
        if (mode == 1) {
            offset += 0.03;
        }else if(mode == 2) {
            offset += 0.06;
        }
        group.beginTime = now + offset;
        if (i == 2) {
            [layer addAnimation:group forKey:@"group"];
        }else {
            [layer addAnimation:group forKey:nil];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[[self.bubbles objectAtIndex:2] animationForKey:@"group"] isEqual:anim]) {
        YXEventLog(@"---------动画完成");
        if (self.completionBlock) {
            self.completionBlock();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

@end




//    CGFloat radius = 20;
//    CGFloat y = (rangeRect.size.height - 2 * radius) * 0.5 + 6;
//    CALayer *toplayer1 = [CALayer layer];
//    toplayer1.hidden = YES;
//    toplayer1.cornerRadius = radius;
//    toplayer1.backgroundColor = bgColor.CGColor;
//    [self.animateContentView.layer addSublayer:toplayer1];
//    [self.bubbles addObject:toplayer1];
//    toplayer1.frame = CGRectMake(randomMinX + margin - radius, y, 2 * radius, 2 * radius);
//
//    CALayer *toplayer2 = [CALayer layer];
//    toplayer2.hidden = YES;
//    toplayer2.backgroundColor = bgColor.CGColor;
//    toplayer2.cornerRadius = radius;
//    [self.animateContentView.layer addSublayer:toplayer2];
//    [self.bubbles addObject:toplayer2];
//    toplayer2.frame = CGRectMake(randomMinX + 2 * margin - radius, y, 2 * radius, 2 * radius);
