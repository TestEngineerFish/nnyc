//
//  YXRefreshNormalHeader.m
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRefreshNormalHeader.h"

@implementation YXRefreshNormalHeader
- (void)setState:(MJRefreshState)state {
    [super setState:state];
    
    if ([self.delegate respondsToSelector:@selector(refreshNormalHeaderStateChanged:)]) {
        [self.delegate refreshNormalHeaderStateChanged:state];
    }
}
@end
