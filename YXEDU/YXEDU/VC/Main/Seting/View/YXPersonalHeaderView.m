//
//  YXPersonalHeaderCell.m
//  YXEDU
//
//  Created by shiji on 2018/5/28.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalHeaderView.h"
#import "BSCommon.h"

@interface YXPersonalHeaderView ()
@end

@implementation YXPersonalHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0x4DB3FE);
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 20)];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = UIColorOfHex(0xffffff);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"人教版";
        [self addSubview:self.titleLab];
        
        self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, 14, 50, 50)];
        self.titleImage.layer.cornerRadius = 25.0f;
        [self addSubview:self.titleImage];
    }
    return self;
}

@end
