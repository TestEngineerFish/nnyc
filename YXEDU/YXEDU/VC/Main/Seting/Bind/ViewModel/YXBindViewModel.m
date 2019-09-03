//
//  YXBindViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBindViewModel.h"
#import "BSCommon.h"

#import "NSObject+YR.h"
#import "YXHttpService.h"
#import "YX_URL.h"
#import "YXConfigure.h"
#import "YXBindResultModel.h"


@interface YXBindViewModel ()

@end

@implementation YXBindViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)sendSMS:(YXSendSMSModel *)smsModel finish:(finishBlock)block {
    NSDictionary *params = (NSDictionary *)[smsModel yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_SENDSMS parameters:params finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

// 请求图形验证码
- (void)requestGraphCodeMobile:(NSString *)mobile finish:(finishBlock)block {
    [[YXHttpService shared]DOWNLOAD:DOMAIN_CAPTCHA parameters:@{@"mobile":mobile,@"random":@"23244"} progress:^(NSProgress *downloadProgress) {
        
    } completion:^(id responseObject) {
        block(responseObject, YES);
    }];
//    [[YXHttpService shared]GET:DOMAIN_CAPTCHA parameters:@{@"mobile":mobile,@"random":@"23244"} finshedBlock:^(id obj, BOOL result) {
//        block(obj, result);
//    }];
}

- (void)bindPhone:(YXBindModel *)model finish:(finishBlock)block {
    NSDictionary *params = (NSDictionary *)[model yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_BINDMOBILE parameters:params finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXBindResultModel *bindResult = [YXBindResultModel yrModelWithJSON:obj];
            [YXConfigure shared].loginModel.user.mobile = bindResult.bindmobile.mobile;
            block(obj, result);
        } else {
            block(obj, result);
        }
    }];
}


@end
