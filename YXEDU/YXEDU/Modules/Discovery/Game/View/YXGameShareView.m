
//
//  YXGameShareView.m
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameShareView.h"

@implementation YXGameShareView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"邀请朋友一起挑战";
        tipsLabel.font = [UIFont pfSCLightFontWithSize:AdaptSize(14)];
        tipsLabel.textColor = UIColorOfHex(0x7A94A8);
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
            make.height.mas_equalTo(AdaptSize(15));
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = UIColorOfHex(0xCFDEE1);
        [self addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tipsLabel);
            make.left.equalTo(self).offset(AdaptSize(15));
            make.right.equalTo(tipsLabel.mas_left).offset(-6);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = UIColorOfHex(0xCFDEE1);
        [self addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tipsLabel);
            make.right.equalTo(self).offset(-AdaptSize(15));
            make.left.equalTo(tipsLabel.mas_right).offset(6);
            make.height.mas_equalTo(0.5);
        }];
        
        
        UIButton *timeLineBtn = [[UIButton alloc] init];
        [timeLineBtn addTarget:self action:@selector(sharedAction:)  forControlEvents:UIControlEventTouchUpInside];
        timeLineBtn.tag = YXShareWXTimeLine;
        [timeLineBtn setImage:[UIImage imageNamed:@"gameShareTimeLine"] forState:UIControlStateNormal];
        [self addSubview:timeLineBtn];
        [timeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(tipsLabel.mas_bottom).offset(AdaptSize(15));
            make.size.mas_equalTo(MakeAdaptCGSize(53, 76));
        }];
        
        UIButton *wxBtn = [[UIButton alloc] init];
        [wxBtn addTarget:self action:@selector(sharedAction:)  forControlEvents:UIControlEventTouchUpInside];
        wxBtn.tag = YXShareWXSession;
        [wxBtn setImage:[UIImage imageNamed:@"gameShareWX"] forState:UIControlStateNormal];
        [self addSubview:wxBtn];
        [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(timeLineBtn.mas_left).offset(-AdaptSize(60));
            make.size.top.equalTo(timeLineBtn);
        }];
        
        UIButton *qqBtn = [[UIButton alloc] init];
        [qqBtn addTarget:self action:@selector(sharedAction:)  forControlEvents:UIControlEventTouchUpInside];
        qqBtn.tag = YXShareQQ;
        [qqBtn setImage:[UIImage imageNamed:@"gameShareQQ"] forState:UIControlStateNormal];
        [self addSubview:qqBtn];
        [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLineBtn.mas_right).offset(AdaptSize(60));
            make.size.top.equalTo(timeLineBtn);
        }];
    }
    return self;
}

- (void)sharedAction:(UIButton *)btn {
    if (self.shareBlock) {
        self.shareBlock(btn.tag);
    }
}
@end
