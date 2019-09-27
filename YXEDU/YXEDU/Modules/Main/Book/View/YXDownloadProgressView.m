//
//  YXDownloadProgressView.m
//  YXEDU
//
//  Created by yao on 2018/10/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDownloadProgressView.h"

@implementation YXDownloadProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.progressTintColor = [UIColor whiteColor];
        self.trackTintColor = [UIColor clearColor];
//        self.roundedCorners = YES;
        self.thicknessRatio = 1.f;
    }
    return self;
}

@end
