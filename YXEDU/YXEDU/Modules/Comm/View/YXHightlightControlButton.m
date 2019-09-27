//
//  YXHightlightControlButton.m
//  YXEDU
//
//  Created by yao on 2019/2/27.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXHightlightControlButton.h"

@implementation YXHightlightControlButton
- (void)setHighlighted:(BOOL)highlighted {
    if (!self.forbidHighLightState) {
        [super setHighlighted:highlighted];
    }
}

@end
