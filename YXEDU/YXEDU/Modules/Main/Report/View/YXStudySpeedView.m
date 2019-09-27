//
//  YXStudySpeedView.m
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudySpeedView.h"
static CGFloat const YXSpeedLayerHeight = 43;
@interface YXStudySpeedView ()
@property (nonatomic, weak)UIImageView *platformIcon;
@property (nonatomic, weak)UIImageView *myIcon;
@property (nonatomic, weak)UIImageView *myIconBG;
@property (nonatomic, weak)CAGradientLayer *myGradientLayer;
@property (nonatomic, weak)CAGradientLayer *platGradientLayer;

@property (nonatomic, weak)CATextLayer *mySpeedTitle;
@property (nonatomic, weak)CATextLayer *platformTitle;
@property (nonatomic, assign)CGFloat mySpeedPercent;
@property (nonatomic, assign)CGFloat platSpeedPercent;
@end


@implementation YXStudySpeedView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleL.text = @"学习速度";
    
        NSArray *colors =@[(__bridge id)UIColor.whiteColor.CGColor, (__bridge id)UIColorOfHex(0xC0D8FF).CGColor];
        CAGradientLayer *myGradientLayer = [self gradinatLayerWithColors:colors];
        [self.layer addSublayer:myGradientLayer];
        _myGradientLayer = myGradientLayer;
        
        colors = @[(__bridge id)UIColor.whiteColor.CGColor, (__bridge id)UIColorOfHex(0xD0BFFD).CGColor];
        CAGradientLayer *platGradientLayer = [self gradinatLayerWithColors:colors];
        [self.layer addSublayer:platGradientLayer];
        _platGradientLayer = platGradientLayer;
        
        UIImageView *platformIcon = [[UIImageView alloc] init];
        platformIcon.image = [UIImage imageNamed:@"reportSpeedPlatf"];
        [self addSubview:platformIcon];
        _platformIcon = platformIcon;
        
        UIImageView *myIconBG = [[UIImageView alloc] init];
        myIconBG.image = [UIImage imageNamed:@"reportMyIconBG"];
        [self addSubview:myIconBG];
        _myIconBG = myIconBG;
        
        UIImageView *myIcon = [[UIImageView alloc] init];
        myIcon.contentMode = UIViewContentModeScaleAspectFill;
        myIcon.layer.cornerRadius = AdaptSize(25);
        myIcon.layer.masksToBounds = YES;
        myIcon.image = [UIImage imageNamed:@"placeholder"];
        [myIconBG addSubview:myIcon];
        _myIcon = myIcon;
        
        CATextLayer *mySpeedTitle = [self textLayerWithColor:UIColorOfHex(0x0C56C5)];
        [myGradientLayer addSublayer:mySpeedTitle];
        _mySpeedTitle = mySpeedTitle;
        
        CATextLayer *platformTitle = [self textLayerWithColor:UIColorOfHex(0x793BCB)];
        [platGradientLayer addSublayer:platformTitle];
        _platformTitle = platformTitle;
    }
    return self;
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
    [self.myIcon sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)refreshWith:(NSString *)mySpeed platform:(NSString *)ptSpeed {
    CGFloat mySpeedValue = [mySpeed floatValue];
    CGFloat ptSpeedValue = [ptSpeed floatValue];
    
    if (mySpeedValue > ptSpeedValue) {
        self.mySpeedPercent = 1;
        self.platSpeedPercent = ptSpeedValue / mySpeedValue;
    }else {
        self.mySpeedPercent = mySpeedValue / ptSpeedValue;
        self.platSpeedPercent = 1;
    }
    self.mySpeedTitle.string = [NSString stringWithFormat:@"我：%.2f word/min",mySpeedValue];
    self.platformTitle.string = [NSString stringWithFormat:@"平台：%.2f word/min",ptSpeedValue];
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = AdaptSize(10);
    CGFloat iconBGW = AdaptSize(70);
    CGRect iconBGRect = CGRectMake(margin, AdaptSize(45), iconBGW, iconBGW);
    self.myIconBG.frame = iconBGRect;
    
    CGFloat iconWH = AdaptSize(50);
    CGFloat iconXY = (iconBGW - iconWH) * 0.5;
    self.myIcon.frame = CGRectMake(iconXY- AdaptSize(2.5), iconXY, iconWH, iconWH);
    
    iconBGRect.origin.y = self.myIconBG.bottom + AdaptSize(8);
    self.platformIcon.frame = iconBGRect;
    
    CGFloat layerH = AdaptSize(YXSpeedLayerHeight);
    CGFloat layerRadius = self.myGradientLayer.cornerRadius;
    CGFloat y = self.myIconBG.center.y - layerH * 0.5;
    CGFloat layerX = margin + AdaptSize(6);
    
    CGFloat layerDefaultWidth = AdaptSize(129) + layerRadius + iconBGW - AdaptSize(6);
    
    CGFloat avaiableScaleW = self.bounds.size.width - layerX - layerDefaultWidth - margin;
    CGFloat mylayerW = avaiableScaleW * self.mySpeedPercent + layerDefaultWidth;
    CGRect layerFrame = CGRectMake(layerX, y, mylayerW, layerH);
    
    self.myGradientLayer.frame = layerFrame;
    layerFrame.origin.y = self.platformIcon.center.y - layerH * 0.5;
    layerFrame.size.width = avaiableScaleW * self.platSpeedPercent + layerDefaultWidth;
    self.platGradientLayer.frame = layerFrame;
    
    CGFloat titleX = iconBGW - AdaptSize(6);
    CGFloat titleH = AdaptSize(16);
    CGFloat titleY = (layerH - titleH) * 0.5;
    
    CGRect oriTitleFrame = CGRectMake(titleX, titleY, mylayerW - titleX - layerRadius,titleH);
    self.mySpeedTitle.frame = oriTitleFrame;
    oriTitleFrame.size.width = layerFrame.size.width - titleX - layerRadius;
    self.platformTitle.frame = oriTitleFrame;
}


- (CAGradientLayer *)gradinatLayerWithColors:(NSArray *)colors {
    CAGradientLayer *gradinatLayer = [CAGradientLayer layer];
    gradinatLayer.cornerRadius = AdaptSize(YXSpeedLayerHeight) * 0.5;
    gradinatLayer.colors = colors;
    gradinatLayer.locations = @[@0.0,@0.8];
    gradinatLayer.startPoint = CGPointMake(0, 0);
    gradinatLayer.endPoint = CGPointMake(1, 0);
    return gradinatLayer;
}

- (CATextLayer *)textLayerWithColor:(UIColor *)color {
    CATextLayer *textlayer = [CATextLayer layer];
    textlayer.contentsScale = [UIScreen mainScreen].scale; // 文字模糊
    textlayer.fontSize = AdaptSize(14);
    textlayer.alignmentMode = kCAAlignmentRight;
    textlayer.foregroundColor = color.CGColor;
    return textlayer;
}
@end
