//
//  YXArticleDetailFresherGuideView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/6.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleDetailFresherGuideView.h"
#import "UIDevice+YX.h"

@interface YXArticleDetailFresherGuideView ()

@property (nonatomic, assign) NSInteger tapNum;
@property (nonatomic, weak)   UIImageView *imageView;
@property (nonatomic, weak)   id<YXArticleDetailFresherGuideViewDelegate> delegate;

@end

@implementation YXArticleDetailFresherGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return self;
}

+ (YXArticleDetailFresherGuideView *)showGuideViewToView:(UIView *)view delegate:(id<YXArticleDetailFresherGuideViewDelegate>)delegate {
    YXArticleDetailFresherGuideView *guideView = [[YXArticleDetailFresherGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    guideView.delegate = delegate;
    [view addSubview:guideView];
    [guideView tapAction];
    return guideView;
}

#pragma mark - event
- (void)tapAction {
    if (self.tapNum < 3) {
        NSString *name = [NSString stringWithFormat:@"FresherGuide/article_detail_fresher_guide%zd@2x.png",self.tapNum];
        NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
        self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }

    if (self.tapNum == 0) {
        [self firstStep];
    } else if (self.tapNum == 1) {
        [self secondStep];
    } else if (self.tapNum == 2) {
        [self thirdlyStep];
    } else {
        [self fresherGuideShowed];
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    self.tapNum ++;
}

- (void)firstStep {
    CGRect maskFrame = CGRectMake(10, SCREEN_HEIGHT - 45 - kSafeBottomMargin, 50, 50);

    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRoundedRect:maskFrame cornerRadius:25.f] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;

    self.layer.mask = mask;

    CGFloat imageW = AdaptSize(297);
    CGFloat imageH = AdaptSize(170);
    CGFloat y = CGRectGetMinY(maskFrame) - imageH - 5;
    CGFloat x = CGRectGetMidX(maskFrame) - 5;;
    self.imageView.frame = CGRectMake(x, y, imageW, imageH);
}

- (void)secondStep {
    if ([self.delegate respondsToSelector:@selector(stepPrecondition:)]) {
        [self.delegate stepPrecondition:self.tapNum];
    }
    CGRect maskFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(fresherGuideViewBlankArea:stepIndex:)]) {
        maskFrame = [self.delegate fresherGuideViewBlankArea:self stepIndex:self.tapNum];
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRoundedRect:maskFrame cornerRadius:7.f] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;

    self.layer.mask = mask;
    CGFloat width = SCREEN_WIDTH - 38.f;
    CGFloat height = 180.f;
    self.imageView.frame = CGRectMake(maskFrame.origin.x + 12, maskFrame.origin.y - height - 7, width, height);
}
- (void)thirdlyStep {
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    mask.path = bezierPath.CGPath;
    self.layer.mask = mask;

    CGFloat width  = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    self.imageView.frame = CGRectMake(0, 0, width, height);
}

+ (BOOL)isFresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-%@-articleDetailFresherGuideKey",[[UIDevice currentDevice] appVersion], [YXConfigure shared].loginModel.user.mobile];
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
    return isShow;
}

- (void)fresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-%@-articleDetailFresherGuideKey",[[UIDevice currentDevice] appVersion], [YXConfigure shared].loginModel.user.mobile];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
