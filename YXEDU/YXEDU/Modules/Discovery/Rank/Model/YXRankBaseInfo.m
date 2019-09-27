//
//  YXRankBaseInfo.m
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRankBaseInfo.h"

@implementation YXRankBaseInfo
- (NSString *)spendTime {
    if (!_spendTime) {
        NSInteger minute = self.speedTime / 60;
        NSInteger second = self.speedTime % 60;
        _spendTime = [NSString stringWithFormat:@"%zd:%02zd",minute,second];
    }
    return _spendTime;
}
@end
