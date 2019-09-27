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
#import "YXAPI.h"
#import "YXConfigure.h"
#import "YXReportDeviceModel.h"
#import "YXAPI.h"
#import "YXUtils.h"
#import "YXComHttpService.h"
#import "JPUSHService.h"

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

- (void)login:(YXLoginSendModel *)sendModel finishedBlock:(YXFinishBlock)finishedBlock {
//    NSDictionary *params = (NSDictionary *)[sendModel yrModelToDictionary];
//    [YXDataProcessCenter POST:DOMAIN_LOGIN parameters:params finshedBlock:^(YRHttpResponse *response, BOOL result) {
//        if (result) {
//            // TODO::存储code
//            [YXConfigure shared].token = response.responseObject[@"token"];
//            [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
//                finishedBlock(response,result);
//            }];
//        } else {
//            finishedBlock(response, result);
//        }
//    }];
    
    NSDictionary *params = (NSDictionary *)[sendModel yrModelToDictionary];
    [YXDataProcessCenter POST:DOMAIN_LOGIN parameters:params finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            // TODO::存储code
            [YXConfigure shared].token = response.responseObject[@"token"];
            [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
                finishedBlock(response,result);
            }];
        } else {
            finishedBlock(response, result);
        }
    }];
}




- (void)login:(YXLoginSendModel *)sendModel finished:(finishBlock)block {
    [self requestCode:sendModel finshed:^(id obj, BOOL result) { //登陆成功
        if (result) {
            [self requestUserInfo:^(id obj, BOOL result) { // 获取用户信息
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

//- (void)requestConfig:(YXFinishBlock)finishBlock {
//    [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
//
//    }]
//}
// 上报设备信息
- (void)reportDeviceStatistics:(finishBlock)block {
    YXReportDeviceModel *reportModel = [[YXReportDeviceModel alloc]init];
    reportModel.devices_id = [YXConfigure shared].deviceId;
    reportModel.ssid = [YXUtils currentWifiSSID];
    reportModel.jp_registration_id = JPUSHService.registrationID;
    reportModel.os = @"iOS";
    reportModel.jp_devices_id = [YXConfigure shared].deviceId;
    reportModel.location = [NSString stringWithFormat:@"%f,%f", [YXConfigure shared].location.coordinate.latitude,[YXConfigure shared].location.coordinate.longitude];
    NSDictionary *dic = (NSDictionary *)[reportModel yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_STATISTICS parameters:dic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

@end
