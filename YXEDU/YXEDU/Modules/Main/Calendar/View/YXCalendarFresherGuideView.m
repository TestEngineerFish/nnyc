//
//  YXCalendarFresherGuideView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/5.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarFresherGuideView.h"
#import "UIDevice+YX.h"

@interface YXCalendarFresherGuideView()
@property (nonatomic, assign)NSInteger tapNum;
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation YXCalendarFresherGuideView

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
    }
    return self;
}

+ (YXCalendarFresherGuideView *)showGuideViewToView:(UIView *)view delegate:(id<YXCalendarFresherGuideViewDelegate>)delegate {
    YXCalendarFresherGuideView *guideView = [[YXCalendarFresherGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    guideView.delegate = delegate;
    [view addSubview:guideView];
    [guideView tapAction];
    return guideView;
}

- (void)tapAction {
    if (self.tapNum < 2) {
        NSString *name = [NSString stringWithFormat:@"FresherGuide/calendar_fresher_guide%zd@2x.png",self.tapNum];
        NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
        self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }

    if (self.tapNum == 0) {
        [self firstStep];
    } else if (self.tapNum == 1) {
        [self secondStep];
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
    CGRect maskFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(fresherGuideViewBlankArea:stepIndex:)]) {
        maskFrame = [self.delegate fresherGuideViewBlankArea:self stepIndex:self.tapNum + 1];
    }

    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *roundBezier = [[UIBezierPath bezierPathWithRoundedRect:maskFrame cornerRadius:13.5] bezierPathByReversingPath];
    [bezierPath appendPath:roundBezier];
    mask.path = bezierPath.CGPath;

    self.layer.mask = mask;

    CGFloat imageW = AdaptSize(280);
    CGFloat imageH = AdaptSize(280);
    CGFloat y = CGRectGetMaxY(maskFrame);
    CGFloat x = SCREEN_WIDTH - 40 - imageW;
    self.imageView.frame = CGRectMake(x, y + 10, imageW, imageH);
}

- (void)secondStep {
    if ([self.delegate respondsToSelector:@selector(stepPrecondition:)]) {
        [self.delegate stepPrecondition:self.tapNum + 1];
    }
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    mask.path = bezierPath.CGPath;
    self.layer.mask = mask;
    CGFloat width = AdaptSize(200.f);
    CGFloat height = AdaptSize(190.f);
    self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, AdaptSize(160.f), width, height);
}

+ (BOOL)isFresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-calendarFresherGuideKey",[[UIDevice currentDevice] appVersion]];
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
    return isShow;
}


- (void)fresherGuideShowed {
    NSString *key = [NSString stringWithFormat:@"k%@-calendarFresherGuideKey",[[UIDevice currentDevice] appVersion]];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
