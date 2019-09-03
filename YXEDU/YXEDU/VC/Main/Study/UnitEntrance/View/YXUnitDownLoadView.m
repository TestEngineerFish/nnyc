//
//  YXUnitDownLoadView.m
//  YXEDU
//
//  Created by shiji on 2018/6/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXUnitDownLoadView.h"
#import "BSCommon.h"

@interface YXUnitDownLoadView ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *pannelView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *progressBlueView;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation YXUnitDownLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.3;
        self.maskView.userInteractionEnabled = YES;
        self.maskView.exclusiveTouch = YES;
        [self addSubview:self.maskView];
        
        self.pannelView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-140)/2.0, 200, 140)];
        self.pannelView.backgroundColor = UIColorOfHex(0xffffff);
        self.pannelView.layer.cornerRadius = 8.0f;
        self.pannelView.clipsToBounds = YES;
        [self addSubview:self.pannelView];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 20)];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.text = @"正在下载素材包…";
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self.pannelView addSubview:self.titleLab];
        
        self.progressView = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(self.titleLab.frame)+15, 130, 13)];
        self.progressView.backgroundColor = UIColorOfHex(0xE0E0E0);
        self.progressView.layer.cornerRadius = 6.5f;
        self.progressView.clipsToBounds = YES;
        [self.pannelView addSubview:self.progressView];
        
        self.progressBlueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 13)];
        self.progressBlueView.backgroundColor = UIColorOfHex(0xE0E0E0);
        [self.progressView addSubview:self.progressBlueView];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"personal_bind_btn"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.pannelView addSubview:self.cancelBtn];
        [self.cancelBtn setFrame:CGRectMake(55, CGRectGetMaxY(self.progressView.frame)+20, 90, 32)];
    }
    return self;
}

- (void)cancelBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBtnDidClicked:)]) {
        [self.delegate cancelBtnDidClicked:sender];
    }
}

+ (id)showDownLoadView:(UIView *)_view
                rootVC:(id<YXUnitDownLoadViewDelegate>)root{
    YXUnitDownLoadView *downloadView = [[YXUnitDownLoadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [downloadView setDelegate:root];
    [_view addSubview:downloadView];
    return downloadView;
}

- (void)updateProgress:(float)progress {
    CGRect progressRect = self.progressView.frame;
    CGRect blueRect = CGRectMake(0, 0, progressRect.size.width * progress, progressRect.size.height);
    self.progressBlueView.frame = blueRect;
    [self resetGraident];
}

- (void)resetGraident {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.progressBlueView.frame.size.width, self.progressBlueView.frame.size.height);  // 设置显示的frame
    gradientLayer.colors = @[(id)UIColorOfHex(0x4DB3FE).CGColor,(id)UIColorOfHex(0x79DCFF).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(1, 0);     //
    [self.progressBlueView.layer addSublayer:gradientLayer];
}

@end
