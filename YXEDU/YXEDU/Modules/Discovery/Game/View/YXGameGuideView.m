//
//  YXGameGuideView.m
//  YXEDU
//
//  Created by yao on 2019/1/3.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameGuideView.h"
@interface YXGameGuideView ()
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, weak) UIImageView *tipsImageView;
@end

@implementation YXGameGuideView
+ (YXGameGuideView *)gameGuideShowToView:(UIView *)view delegate:(id<YXGameGuideViewDelegate>)delegate {
    YXGameGuideView *guideView = [[YXGameGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.delegate = delegate;
    [view addSubview:guideView];
    return guideView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.step = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextStep)];
        [self addGestureRecognizer:tap];
        [self nextStep];
    }
    return self;
}

- (void)nextStep {
    self.step ++;
    if (self.step > 3) { //finish
        [self gameGuideShowed:self.gameGuideKey];
        [self removeFromSuperview];
    }else {
        NSString *name = [NSString stringWithFormat:@"oneDrawgameGuide%zd@2x.png",self.step];
        NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
        self.tipsImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        
        if (kIsIPhoneXSerious) {
            [self iphoneXSeriousGuideStep];
        }else {
            if (self.step == 1) {
                self.tipsImageView.frame = CGRectMake(AdaptSize(2), AdaptSize(111), AdaptSize(301), AdaptSize(219));
            }else if(self.step == 2){
                CGFloat sunX = SCREEN_WIDTH - AdaptSize(18) - AdaptSize(304);
                self.tipsImageView.frame = CGRectMake(sunX, AdaptSize(26), AdaptSize(304), AdaptSize(214));
            }else {
                self.tipsImageView.frame = CGRectMake(0, 0, AdaptSize(286.5), AdaptSize(523));
                self.tipsImageView.center = self.center;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(gameGuideView:guideStep:)]) {
        [self.delegate gameGuideView:self guideStep:self.step];
    }

}

- (void)iphoneXSeriousGuideStep {
    if (self.step == 1) {
        self.tipsImageView.frame = CGRectMake(AdaptSize(2), AdaptSize(185), AdaptSize(301), AdaptSize(219));
    }else if(self.step == 2){
        CGFloat sunX = SCREEN_WIDTH - AdaptSize(8.5) - AdaptSize(304);
        self.tipsImageView.frame = CGRectMake(sunX, AdaptSize(41.5), AdaptSize(304), AdaptSize(214));
    }else {
        self.tipsImageView.frame = CGRectMake(0, 0, AdaptSize(286.5), AdaptSize(523));
        self.tipsImageView.center = self.center;
    }
}

#pragma mark - subviews
- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        UIImageView *tipsImageView = [[UIImageView alloc] init];
        tipsImageView.userInteractionEnabled = YES;
        [self addSubview:tipsImageView];
        _tipsImageView = tipsImageView;
    }
    return _tipsImageView;
}

#pragma mark - guideView
+ (BOOL)isGameGuideShowedWith:(NSString *)gameKey {
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:gameKey] boolValue];
    return isShow;
}

- (void)gameGuideShowed:(NSString *)gameKey {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:gameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
