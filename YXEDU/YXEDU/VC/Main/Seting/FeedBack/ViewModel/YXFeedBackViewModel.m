//
//  YXFeedBackViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFeedBackViewModel.h"
#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YX_URL.h"

@interface YXFeedBackViewModel ()

@end

@implementation YXFeedBackViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)submitFeedBack:(YXFeedSendModel *)sendModel finish:(finishBlock)block {
    [[YXHttpService shared]UPLOAD:DOMAIN_FEEDBACK parameters:@{@"feed":sendModel.feed, @"env":sendModel.env} datas:sendModel.files finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

@end
