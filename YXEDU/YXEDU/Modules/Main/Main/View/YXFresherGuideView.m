
//
//  YXFresherGuideView.m
//  YXEDU
//
//  Created by yao on 2018/11/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFresherGuideView.h"
#import "UIDevice+YX.h"
@interface YXFresherGuideView ()
@property (nonatomic, assign)NSInteger tapNum;
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation YXFresherGuideView
- (NSInteger)step {
    return _tapNum;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _imageView = imageView;
//        [self firstStep];
        [self tapAction];
    }
    return self;
}

+ (YXFresherGuideView *)showGuideViewToView:(UIView *)view delegate:(id<YXFresherGuideViewDelegate>)delegate{
    YXFresherGuideView *guideView = [[YXFresherGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    guideView.delegate = delegate;
    [view addSubview:guideView];
    return guideView;
}

- (void)firstStep {
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CGRect maskFrame = CGRectMake(15 , kStatusBarHeight + 2, 40, 40);
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithOvalInRect:maskFrame] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;
    self.layer.mask = mask;
    
    CGFloat imageW = 302;
    CGFloat y = CGRectGetMaxY(maskFrame);
    CGFloat x = SCREEN_WIDTH - 20 - imageW;
    self.imageView.frame = CGRectMake(x, y, imageW, 128);
}

- (void)secondStep {
//    CGRectMake(SCREEN_WIDTH-82, 95, 82, 27)];
    
    CGRect maskFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(fresherGuideViewBlankArea:stepIndex:)]) {
        maskFrame = [self.delegate fresherGuideViewBlankArea:self stepIndex:self.tapNum + 1];
    }
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
//    CGRect maskFrame = CGRectMake(SCREEN_WIDTH-82 , kNavHeight + 95, 100, 27);
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRoundedRect:maskFrame cornerRadius:13.5] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;
    
    self.layer.mask = mask;
    
    CGFloat imageW = 300;
    CGFloat y = CGRectGetMaxY(maskFrame);
    CGFloat x = SCREEN_WIDTH - 20 - imageW;
    self.imageView.frame = CGRectMake(x, y + 5, imageW, 130);
}

- (void)thirdStep {
    CGRect maskFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(fresherGuideViewBlankArea:stepIndex:)]) {
        maskFrame = [self.delegate fresherGuideViewBlankArea:self stepIndex:self.tapNum + 1];
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
//    CGRect maskFrame = CGRectMake(0 , kNavHeight + 415, SCREEN_WIDTH, 118);
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRect:maskFrame] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;
    self.layer.mask = mask;

    CGFloat imageW = 267;
    CGFloat y = CGRectGetMinY(maskFrame) - 10 - 164;
    CGFloat x = (SCREEN_WIDTH - imageW) * 0.5;
    self.imageView.frame = CGRectMake(x, y + 5, imageW, 164);
}

- (void)fourthStep {
    CGRect maskFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(fresherGuideViewBlankArea:stepIndex:)]) {
        maskFrame = [self.delegate fresherGuideViewBlankArea:self stepIndex:self.tapNum + 1];
    }

    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(maskFrame.origin.x, maskFrame.origin.y, maskFrame.size.width, maskFrame.size.width) cornerRadius:maskFrame.size.width/2] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;

    self.layer.mask = mask;

    CGFloat imageW = AdaptSize(250.f);
    CGFloat imageH = AdaptSize(170.f);
    CGFloat y = maskFrame.origin.y - imageH - 10;
    CGFloat x = (SCREEN_WIDTH - imageW)/2 - 30;
    self.imageView.frame = CGRectMake(x, y + AdaptSize(5.f), imageW, imageH);
}


- (void)tapAction {
    if (self.tapNum < 4) {
        NSString *name = [NSString stringWithFormat:@"FresherGuide/fresher_guide%zd@2x.png",self.tapNum];
        NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
        self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }

    if (self.tapNum == 0) {
        [self firstStep];
    } else if (self.tapNum == 1) {
        [self secondStep];
    } else if (self.tapNum == 2) {
        [self thirdStep];
    } else if (self.tapNum == 3) {
        [self fourthStep];
    } else {
        [self fresherGuideShowed];
        if ([self.delegate respondsToSelector:@selector(fresherGuideViewGuideFinished:)]) {
            [self.delegate fresherGuideViewGuideFinished:self];
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    self.tapNum ++;
}


+ (BOOL)isfresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-fresherGuideKey",[[UIDevice currentDevice] appVersion]];
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
    return isShow;
}

- (void)fresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-fresherGuideKey",[[UIDevice currentDevice] appVersion]];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
