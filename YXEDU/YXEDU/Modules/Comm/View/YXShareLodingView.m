//
//  YXShareLodingView.m
//  YXEDU
//
//  Created by jukai on 2019/5/6.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXShareLodingView.h"

@interface  YXShareLodingView()

@property (nonatomic, strong) YXShareLodingView *shareLodingView;

@property (nonatomic, weak) UIImageView *animationView;

@end

@implementation YXShareLodingView

+ (YXShareLodingView *)showShareLodingInView:(UIView *)view{
    YXShareLodingView *shareView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:shareView];
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorOfHex(0xEEF4FC);
        
        UIImageView *lodingBGView = [[UIImageView alloc]initWithFrame:CGRectMake(15, kStatusBarHeight+13.0, SCREEN_WIDTH-30.0, AdaptSize(530.0))];
        [lodingBGView setImage:[UIImage imageNamed:@"海报加载底块"]];
        [self addSubview:lodingBGView];
        
        lodingBGView.layer.cornerRadius = 13;
        lodingBGView.layer.masksToBounds = YES;
        
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(6, kStatusBarHeight, 34, 34)];
        [cancleBtn setImage:[UIImage imageNamed:@"Share关闭"] forState:UIControlStateNormal];
        [cancleBtn setImage:[UIImage imageNamed:@"Share关闭"] forState:UIControlStateSelected];
        [cancleBtn addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
        UIImageView *animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, AdaptSize(230.0), AdaptSize(64.0), AdaptSize(67.0))];
        [animationView setImage:[UIImage imageNamed:@"海报加载中"]];
        animationView.center = CGPointMake(lodingBGView.center.x-AdaptSize(15.0), lodingBGView.center.y-AdaptSize(33.0));
        [lodingBGView addSubview:animationView];
        self.animationView = animationView;
        
        UIImageView *textView = [[UIImageView alloc]initWithFrame:CGRectMake(0, AdaptSize(230.0), AdaptSize(82.0), AdaptSize(15.0))];
        
        [textView setImage:[UIImage imageNamed:@"海报生成中.."]];
        textView.center = CGPointMake(animationView.center.x, animationView.center.y+AdaptSize(60.0));
        [lodingBGView addSubview:textView];
        
        [self configBtns];
        [self showLoading];
    }
    return self;
}

- (void)cancleShare {
    
    [UIView animateWithDuration:0.3 animations:^{
       [self removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
}

-(void)showLoading{
    
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    rotationAnimation.duration = 1.0;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = 100;
    
    [self.animationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];//开始动画
    
}
-(void)hideLoading{
    
    [self.animationView.layer removeAnimationForKey:@"rotationAnimation"];//开始动画
    
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
}

-(void)configBtns{
    
    float iPhoneXfloat = AdaptSize(601);
    if (kIsIPhoneXSerious){
        iPhoneXfloat = AdaptSize(701);
    }
    
    UIButton *qqBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(17.0), 0 + iPhoneXfloat , AdaptSize(44.0), AdaptSize(45.0))];
    [qqBtn setImage:[UIImage imageNamed:@"qq-灰"] forState:UIControlStateNormal];
    [qqBtn setImage:[UIImage imageNamed:@"qq-灰"] forState:UIControlStateSelected];
    qqBtn.tag = 2;
    
    [self addSubview:qqBtn];
    
    UIButton *wechatBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(74.0), 0+ iPhoneXfloat , AdaptSize(44.0), AdaptSize(45.0))];
    
    [wechatBtn setImage:[UIImage imageNamed:@"微信-灰"] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"微信-灰"] forState:UIControlStateSelected];
    wechatBtn.tag = 0;
    [self addSubview:wechatBtn];
    
    UIButton *wechatFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(137.0), 0 + iPhoneXfloat , AdaptSize(228.0*44.0/49.0), AdaptSize(44.0))];
    //457 × 98
    
    [wechatFriendBtn setImage:[UIImage imageNamed:@"分享朋友圈-灰"] forState:UIControlStateNormal];
    [wechatFriendBtn setImage:[UIImage imageNamed:@"分享朋友圈-灰"] forState:UIControlStateSelected];
    wechatFriendBtn.tag = 1;
    [self addSubview:wechatFriendBtn];
}


@end
