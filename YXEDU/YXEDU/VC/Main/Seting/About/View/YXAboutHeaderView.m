//
//  YXAboutHeaderView.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXAboutHeaderView.h"
#import "BSCommon.h"

@interface YXAboutHeaderView ()
@property (nonatomic, strong) UILabel *versionLab;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YXAboutHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleImgView = [[UIImageView alloc]init];
        [titleImgView setFrame:CGRectMake((SCREEN_WIDTH-114)/2.0, 30, 114, 114)];
        titleImgView.image = [UIImage imageNamed:@"login_icon"];
        [self addSubview:titleImgView];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImgView.frame)+20, SCREEN_WIDTH, 22)];
        titleLab.text = @"念念有词";
        titleLab.textColor = UIColorOfHex(0x535353);
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
        
        self.versionLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), SCREEN_WIDTH, 22)];
        self.versionLab.textColor = UIColorOfHex(0x535353);
        self.versionLab.font = [UIFont systemFontOfSize:16];
        self.versionLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.versionLab];
        NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        self.versionLab.text = [NSString stringWithFormat:@"V%@", string];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 247.5, SCREEN_WIDTH, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.alpha = 0.5;
        [self addSubview:self.lineView];
    }
    return self;
}

@end
