//
//  YXBookCollectionFooter.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookCollectionFooter.h"

@implementation YXBookCollectionFooter
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0xF3F8FB);
    }
    return self;
}

- (void)setIsLastSectionFooter:(BOOL)isLastSectionFooter {
    _isLastSectionFooter = isLastSectionFooter;
    self.backgroundColor = isLastSectionFooter ? [UIColor whiteColor] : UIColorOfHex(0xF3F8FB);
}

@end
