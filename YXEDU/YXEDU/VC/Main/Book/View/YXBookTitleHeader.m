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
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(18, 25, SCREEN_WIDTH, 19)];
        self.nameLab.font = [UIFont boldSystemFontOfSize:15];
        self.nameLab.textColor = UIColorOfHex(0x999999);
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"人教版";
        [self.contentView addSubview:self.nameLab];
    }
    return self;
}

@end
