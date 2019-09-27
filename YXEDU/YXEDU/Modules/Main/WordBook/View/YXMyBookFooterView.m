//
//  YXMyBookFooterView.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyBookFooterView.h"

@implementation YXMyBookFooterView
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorOfHex(0xF3F8FB);
    }
    return self;
}

@end
