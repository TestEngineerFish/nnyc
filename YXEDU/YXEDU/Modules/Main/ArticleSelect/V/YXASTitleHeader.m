//
//  YXASTitleHeader.m
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXASTitleHeader.h"

@implementation YXASTitleHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(17, 15, SCREEN_WIDTH-34.0-20.0, 14)];
        
        self.nameLab.font = [UIFont pfSCMediumFontWithSize:16.0];
        self.nameLab.numberOfLines = 0;
        self.nameLab.textColor = UIColorOfHex(0x55A7FD);
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"头部";
        [self.contentView addSubview:self.nameLab];
        self.nameLab.backgroundColor = [UIColor whiteColor];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(15.0);
            make.left.mas_equalTo(self.contentView).offset(17.0);
            make.right.mas_equalTo(self.contentView).offset(-37.0);
        }];
    }
    return self;
}

@end
