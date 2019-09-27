//
//  YXSpringAnimateButton.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSpringAnimateButton.h"
#import "YXHightlightControlButton.h"
static NSString *const kYXSpringAnimatekey = @"YXSpringAnimatekey";
@interface YXSpringAnimateButton ()<CAAnimationDelegate>
@property (nonatomic, assign, getter=isAnimating) BOOL animating;
@property (nonnull, nonatomic, strong) YXHightlightControlButton *controlButton;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@end

@implementation YXSpringAnimateButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.controlButton = [[YXHightlightControlButton alloc] init];
        [self addSubview:self.controlButton];
    }
    return self;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.controlButton.tag = tag;
}


- (instancetype)initWithNoHighLightState {
    if (self = [super init]) {
        self.forbidHighLightState = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.controlButton.frame = self.bounds;
}

- (UILabel *)titleLabel {
    return self.button.titleLabel;
}

- (UIButton *)button {
    return self.controlButton;
}

- (void)setForbidHighLightState:(BOOL)forbidHighLightState {
    _forbidHighLightState = forbidHighLightState;
    self.controlButton.forbidHighLightState = forbidHighLightState;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.userInteractionEnabled = enabled;
    self.button.enabled = enabled;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [self.button setTitleColor:color forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self.button setTitle:title forState:state];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.button setBackgroundImage:image forState:state];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [self.button setImage:image forState:state];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    self.target = target;
    self.action = action;
    [self.controlButton addTarget:self action:@selector(controlButtonClicked:) forControlEvents:controlEvents];//UIControlEventTouchUpInside
}

- (void)controlButtonClicked:(UIButton *)btn {
    if (!self.isAnimating) {
        self.animating = YES;
        
        CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animater.values = @[@1,@0.85,@1.0];
        animater.duration = 0.25;
        animater.delegate = self;
        animater.removedOnCompletion = NO;// 默认移除动画
        animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [btn.layer addAnimation:animater forKey:kYXSpringAnimatekey];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CAAnimation *addedAnimate = [self.controlButton.layer animationForKey:kYXSpringAnimatekey];
    if ([addedAnimate isEqual:anim]) {
        [self.controlButton.layer removeAnimationForKey:kYXSpringAnimatekey];
        [self singleAction:self.controlButton];
    }
}

- (void)singleAction:(UIButton *)btn {
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.action];
        void (*func)(id,SEL,id) = (void *)imp;
        func(self.target,self.action,btn);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animating = NO;
    });
//    NSLog(@"---------single");
}


@end


//- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    [super sendAction:action to:target forEvent:event];
//    if (self.isAnimating == NO) {
//        self.animating = YES;
//
////        CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
////        animater.values = @[@1,@0.85,@1.0]; //  animater.delegate = self;// 代理传参问题
////        animater.duration = 0.25;
////        animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////        [self.layer addAnimation:animater forKey:nil];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.animating = NO;
//        });
//        [super sendAction:action to:target forEvent:event];
//    }
//    [super sendAction:action to:target forEvent:event];
////    else {
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [super sendAction:action to:target forEvent:event];
////        });
////    }
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    self.animating = NO;
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
//    self.animating = NO;
//}



