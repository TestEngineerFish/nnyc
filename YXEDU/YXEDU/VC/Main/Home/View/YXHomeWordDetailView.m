//
//  YXHomeWordDetailView.m
//  YXEDU
//
//  Created by shiji on 2018/5/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeWordDetailView.h"

@interface YXHomeWordDetailView ()
@property (nonatomic, strong) UILabel *titleLab1;
@property (nonatomic, strong) UILabel *titleLab2;
@property (nonatomic, strong) UIImageView *singleLine;
@end

@implementation YXHomeWordDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(32, 27, SCREEN_WIDTH/2-32, 19)];
        self.titleLab1.font = [UIFont systemFontOfSize:10];
        self.titleLab1.textColor = UIColorOfHex(0xffffff);
        self.titleLab1.textAlignment = NSTextAlignmentCenter;
        self.titleLab1.text = @"总词汇";
        [self addSubview:self.titleLab1];
        
        self.titleLab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 27, SCREEN_WIDTH/2-32, 19)];
        self.titleLab2.font = [UIFont systemFontOfSize:10];
        self.titleLab2.textColor = UIColorOfHex(0xffffff);
        self.titleLab2.textAlignment = NSTextAlignmentCenter;
        self.titleLab2.text = @"已学词汇";
        [self addSubview:self.titleLab2];
        
        self.detailLab1 = [[UILabel alloc]initWithFrame:CGRectMake(32, 46, SCREEN_WIDTH/2-32, 28)];
        self.detailLab1.font = [UIFont boldSystemFontOfSize:36];
        self.detailLab1.textColor = UIColorOfHex(0xffffff);
        self.detailLab1.textAlignment = NSTextAlignmentCenter;
        self.detailLab1.text = @"850";
        [self addSubview:self.detailLab1];
        
        self.detailLab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 46, SCREEN_WIDTH/2-32, 28)];
        self.detailLab2.font = [UIFont boldSystemFontOfSize:36];
        self.detailLab2.textColor = UIColorOfHex(0xffffff);
        self.detailLab2.textAlignment = NSTextAlignmentCenter;
        self.detailLab2.text = @"20";
        [self addSubview:self.detailLab2];
        
    }
    return self;
}

@end
