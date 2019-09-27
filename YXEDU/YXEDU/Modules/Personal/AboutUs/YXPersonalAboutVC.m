//
//  YXPersonalAboutVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalAboutVC.h"
//#import "YXAboutComCell.h"
#import "BSCommon.h"
//#import "YXAboutHeaderView.h"
#import "YXPolicyVC.h"
//#import "YXPersonalFeedBackVC.h"

@interface YXPersonalAboutVC ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *textImage;
@property (nonatomic, strong) UILabel *versonLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *legacyView;

//@property (nonatomic, strong) YXAboutHeaderView *aboutHeaderView;

@end

@implementation YXPersonalAboutVC

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor whiteColor];//UIColorOfHex(0x4DB3FE);
    
    self.iconImage = [[UIImageView alloc] init];
    
    self.iconImage.image = [UIImage imageNamed:@"组3"];
    self.iconImage.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
    self.iconImage.layer.shadowRadius = 2.5;
    self.iconImage.layer.shadowOpacity = 0.6;
    self.iconImage.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.textImage = [[UIImageView alloc] init];
    self.textImage.contentMode = UIViewContentModeScaleAspectFit;
    self.textImage.image = [UIImage imageNamed:@"念念有词"];
    
    self.versonLabel = [[UILabel alloc] init];
    self.versonLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versonLabel.textColor = UIColorOfHex(0x8095AB);
    self.versonLabel.font = [UIFont systemFontOfSize:16];
    self.versonLabel.textAlignment = NSTextAlignmentCenter;
    
    self.legacyView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPolicy)];
    [self.legacyView addGestureRecognizer:tap];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.text = @"Copyright ©2018-2019 念念有词";
    self.rightLabel.textColor = UIColorOfHex(0x8095AB);
    self.rightLabel.font = [UIFont systemFontOfSize:12];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.textImage];
    [self.view addSubview:self.iconImage];
    [self.view addSubview:self.versonLabel];
    [self.view addSubview:self.legacyView];
    [self.view addSubview:self.rightLabel];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(64);
        make.top.equalTo(self.view).offset(60);
        make.centerX.equalTo(self.view);
    }];
    
    [self.textImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(64);
        make.top.equalTo(self.iconImage.mas_bottom).offset(8);
        make.centerX.equalTo(self.view);
    }];
    
    [self.versonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textImage.mas_bottom).offset(4);
        make.centerX.equalTo(self.view);
    }];
    
    [self.legacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.equalTo(self.view);
        make.centerX.centerY.equalTo(self.view);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(- 16 - kSafeBottomMargin);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"用户协议";
    titleLabel.textColor = UIColorOfHex(0x485461);
    
    UIImageView *accessoryImage = [[UIImageView alloc] init];
    accessoryImage.image = [UIImage imageNamed:@"圆角矩形"];
    accessoryImage.tintColor = UIColorOfHex(0x849EC5);
    accessoryImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorOfHex(0xE1EBF0);
    
    [self.legacyView addSubview:titleLabel];
    [self.legacyView addSubview:accessoryImage];
    [self.legacyView addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.legacyView).offset(16);
        make.centerY.equalTo(self.legacyView);
    }];
    
    [accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(self.legacyView);
        make.right.equalTo(self.legacyView).offset(-16);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.legacyView).offset(16);
        make.right.equalTo(self.legacyView).offset(-16);
        make.bottom.equalTo(self.legacyView);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)pushPolicy {
    YXPolicyVC *policyVC = [[YXPolicyVC alloc]init];
    [self.navigationController pushViewController:policyVC animated:YES];
}

@end
