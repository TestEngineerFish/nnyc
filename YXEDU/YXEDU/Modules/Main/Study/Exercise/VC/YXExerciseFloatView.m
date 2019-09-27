//
//  YXExerciseFloatView.m
//  YXEDU
//
//  Created by shiji on 2018/6/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXExerciseFloatView.h"
#import "BSCommon.h"
#import "YXAPI.h"
#import "UIImageView+WebCache.h"
#import "YXUtils.h"

@interface YXExerciseFloatView ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *floatView;
@property (nonatomic, strong) UIImageView *screentShotView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *titleBtn;
@end


@implementation YXExerciseFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [self removeAllSubViews];
    } else {
        [self recreateSubViews];
    }
}

- (void)tapAction:(UIGestureRecognizer *)gesture {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.floatView.frame = CGRectMake(SCREEN_WIDTH, (SCREEN_HEIGHT - kNavHeight - 160)* 0.5, 100, 160);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.userInteractionEnabled = YES;
    }];
}

- (void)recreateSubViews {
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.alpha = 1;
    self.maskView.userInteractionEnabled = YES;
    self.maskView.exclusiveTouch = YES;
    [self addSubview:self.maskView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.maskView addGestureRecognizer:tapGesture];
    
//    CGFloat margin = 7;
    CGFloat floatVWidth = 100;
    CGFloat sumitBtnHeight = 25;
    CGFloat screenShotWidth = 86;
    CGFloat screenShotHeight = screenShotWidth * kScreenScale;
    CGFloat floatVHeight = 160;//14 + screenShotHeight + 20;
    self.floatView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-109, (SCREEN_HEIGHT - kNavHeight - floatVHeight)* 0.5, floatVWidth, floatVHeight)];
    self.floatView.exclusiveTouch = YES;
    self.floatView.layer.masksToBounds = YES;
    self.floatView.backgroundColor = UIColorOfHex(0x535353);
    self.floatView.userInteractionEnabled = YES;
    [self addSubview:self.floatView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSubmitVC)];
    [self.floatView addGestureRecognizer:tap];
    
    
    
    self.screentShotView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, screenShotWidth, screenShotHeight)];
    self.screentShotView.userInteractionEnabled = YES;
    self.screentShotView.image = [UIImage imageNamed:@"home_flower"];
    self.screentShotView.contentMode = UIViewContentModeScaleAspectFill;
    [self.floatView addSubview:self.screentShotView];
//    [self.screentShotView sd_setImageWithURL:[NSURL fileURLWithPath:[YXUtils screenShoutPath]]];
    
//    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 134, 16, 16)];
//    self.iconImageView.image = [UIImage imageNamed:@"study_screen_icon"];
//    [self.floatView addSubview:self.iconImageView];
//
//    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.titleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [self.titleBtn setFrame:CGRectMake(35, 130, 60, 20)];
//    [self.titleBtn setTitle:@"反馈问题" forState:UIControlStateNormal];
//    [self.titleBtn setTitleColor:UIColorOfHex(0xFFBF4C) forState:UIControlStateNormal];
//    [self.titleBtn addTarget:self action:@selector(gotoSubmitVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.floatView addSubview:self.titleBtn];
    
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, floatVHeight - sumitBtnHeight, floatVWidth, sumitBtnHeight)];
    titleBtn.backgroundColor = UIColorOfHex(0x535353);
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleBtn setTitleColor:UIColorOfHex(0xFFBF4C) forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"study_screen_icon"] forState:UIControlStateNormal];
    [titleBtn setTitle:@"  反馈问题" forState:UIControlStateNormal];
    [self.floatView addSubview:titleBtn];
    [titleBtn addTarget:self action:@selector(gotoSubmitVC) forControlEvents:UIControlEventTouchUpInside];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)removeAllSubViews {
    RELEASE(_maskView);
    RELEASE(_floatView);
    RELEASE(_screentShotView);
    RELEASE(_iconImageView);
    RELEASE(_titleBtn);
    [YXUtils removeScreenShout];
}

- (void)gotoSubmitVC {
    [self tapAction:nil];
    if ([self.delegate respondsToSelector:@selector(exerciseFloatViewSubmmit:)]) {
        [self.delegate exerciseFloatViewSubmmit:self];
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(submitBtnClicked:)]) {
//        [self.delegate submitBtnClicked:sender];
//    }
}

-(void)setSnapShoptImage:(UIImage *)snapShoptImage {
    _snapShoptImage = snapShoptImage;
    self.hidden = NO;
    self.screentShotView.image = snapShoptImage;
}


@end
