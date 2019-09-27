//
//  YXBookTitleHeader.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookTitleHeader.h"
#import "BSCommon.h"

@interface YXBookTitleHeader ()

@end

@implementation YXBookTitleHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH, 16)];
        self.nameLab.font = [UIFont boldSystemFontOfSize:15];
        self.nameLab.textColor = UIColorOfHex(0x8095AB);
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"人教版";
        [self.contentView addSubview:self.nameLab];
        self.nameLab.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
