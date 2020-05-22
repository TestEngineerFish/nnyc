//
//  YXFeedBackViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFeedBackViewModel.h"
#import "NSObject+YR.h"
#import "YXAPI.h"

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
    [[YYNetworkService default] ocRequestWithType:YXOCRequestTypeFeedback params:@{@"feed": sendModel.feed, @"env": sendModel.env, @"files": sendModel.files} isUpload:YES success:^(YXOCModel* model) {
        block(model, model != nil);

    } fail:^(NSError* error) {
        
    }];
}

@end
