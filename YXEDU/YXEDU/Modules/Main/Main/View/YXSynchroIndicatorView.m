//
//  YXSynchroIndicatorView.m
//  YXEDU
//
//  Created by yao on 2019/1/10.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSynchroIndicatorView.h"

static CGFloat const kSynchroIndicatorMargin = 7;
static NSString *const kSynchroIndicatorAnimationKey = @"SynchroIndicatorAnimationKey";
@interface YXSynchroIndicatorView()
@property (nonatomic, strong) UIImageView *lodingImageView;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation YXSynchroIndicatorView
{
    UILabel *_tipsLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.layer.masksToBounds = YES;
        self.lodingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SynchroIndicatorImage"]];
        [self addSubview:self.lodingImageView];
        
        [self tipsLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat cornerRadius = size.height * 0.5;
    self.layer.cornerRadius = cornerRadius;
    
    CGFloat lodingDiameter = size.height - 2 * kSynchroIndicatorMargin;
    self.lodingImageView.frame = CGRectMake(cornerRadius, kSynchroIndicatorMargin, lodingDiameter, lodingDiameter);
    CGFloat tispX = cornerRadius + lodingDiameter + kSynchroIndicatorMargin;
    
    self.tipsLabel.frame = CGRectMake(tispX, 0, size.width - tispX, size.height);
    [self startAnimation];
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.font = [UIFont systemFontOfSize:13];
        tipsLabel.textColor = UIColorOfHex(0x1297F8);
        tipsLabel.text = @"正在同步学习数据...";
        [self addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

- (void)startAnimation {
    if (!_isLoading) {
        CAKeyframeAnimation *transformAnima =  [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        transformAnima.values = @[@0,@(M_PI),@(2 * M_PI)];
        transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transformAnima.repeatCount = HUGE_VALF;
        transformAnima.duration = 1;
        transformAnima.removedOnCompletion = NO;
        transformAnima.fillMode = kCAFillModeForwards;
        [self.lodingImageView.layer addAnimation:transformAnima forKey:kSynchroIndicatorAnimationKey];
        _isLoading = YES;
    }
}

- (void)stopAnimation {
    [self.lodingImageView.layer removeAnimationForKey:kSynchroIndicatorAnimationKey];
}

+ (instancetype)synchroIndicatorShowToView:(UIView *)view {
    CGSize size = view.size;
    YXSynchroIndicatorView *synchroIndicatorView = [[self alloc] initWithFrame:CGRectMake(0, 0, 166, 30)];
    synchroIndicatorView.center = CGPointMake(size.width * 0.5, AdaptSize(92));
    [view addSubview:synchroIndicatorView];
    return synchroIndicatorView;
}

- (void)hide {
    [self stopAnimation];
    [self removeFromSuperview];
}
@end
