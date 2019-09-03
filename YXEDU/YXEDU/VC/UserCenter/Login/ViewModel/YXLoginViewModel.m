//
//  YXLoginModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLoginViewModel.h"
#import "YXHttpService.h"
#import "YXLoginModel.h"
#import "NSObject+YR.h"
#import "YX_URL.h"
#import "YXConfigure.h"
#import "YXReportDeviceModel.h"
#import "YXCommHeader.h"
#import "YXUtils.h"
#import "YXComHttpService.h"

@interface YXLoginViewModel ()
@end

@implementation YXLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)login:(YXLoginSendModel *)sendModel finished:(finishBlock)block {
    [self requestCode:sendModel finshed:^(id obj, BOOL result) {
        if (result) {
            [self requestUserInfo:^(id obj, BOOL result) {
                block(obj, result);
            }];
        } else {
            block(obj, result);
        }
    }];
}

// 请求code
- (void)requestCode:(YXLoginSendModel *)sendModel finshed:(finishBlock)block {
    NSDictionary *params = (NSDictionary *)[sendModel yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_LOGIN parameters:params finshedBlock:^(id obj, BOOL result) {
        if (result) {
            // TODO::存储code
            [YXConfigure shared].token = obj[@"token"];
            block(obj, result);
        } else {
            block(obj, result);
        }
    }];
}

// 请求用户信息
- (void)requestUserInfo:(finishBlock)block {
    
    [[YXComHttpService shared]requestUserInfo:^(id obj, BOOL result) {
        if (result) {
            YXLoginModel *model = obj;
            [YXConfigure shared].mobile = model.user.mobile;
            [YXConfigure shared].uuid = model.user.uuid;
        }
        block(obj, result);
    }];
}

// 上报设备信息
- (void)reportDeviceStatistics:(finishBlock)block {
    YXReportDeviceModel *reportModel = [[YXReportDeviceModel alloc]init];
    reportModel.devices_id = [YXConfigure shared].deviceId;
    reportModel.ssid = [YXUtils currentWifiSSID];
    reportModel.jp_registration_id = jgId;
    reportModel.os = @"iOS";
    reportModel.jp_devices_id = [YXConfigure shared].deviceId;
    reportModel.location = [NSString stringWithFormat:@"%f,%f", [YXConfigure shared].location.coordinate.latitude,[YXConfigure shared].location.coordinate.longitude];
    NSDictionary *dic = (NSDictionary *)[reportModel yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_STATISTICS parameters:dic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

@end
