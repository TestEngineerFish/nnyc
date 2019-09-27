//
//  SJSignal.m
//  DEMO_project
//
//  Created by shiji on 2016/12/16.
//  Copyright © 2016年 shiji. All rights reserved.
//

#import "SJCall.h"
CTCALL_STATE SJCallGetCallState(NSString *cState) {
    NSArray *arr = @[CTCallStateDialing,CTCallStateIncoming,CTCallStateConnected,CTCallStateDisconnected];
    switch ([arr indexOfObject:cState]) {
        case 0:return SJCallStateDialing;
        case 1:return SJCallStateIncoming;
        case 2:return SJCallStateConnected;
        case 3:return SJCallStateDisconnected;
        default:return SJCallStateDialing;
    }
}

@interface SJCall()
@property (nonatomic, strong ) SJCarrierInfo * carrierInfo;
@end

static SJCall *callShare;
static CTTelephonyNetworkInfo *ctNetInfo;
static CTCallCenter *callCenter;
static CTCellularData *cellularData;
@implementation SJCall

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        callShare = [SJCall new];
        ctNetInfo = [[CTTelephonyNetworkInfo alloc] init];
        callCenter = [[CTCallCenter alloc] init];
        cellularData = [[CTCellularData alloc]init];
    });
    return callShare;
}

// 获取运营商信息
- (void)carrierInfo:(void(^)(SJCarrierInfo *carrier))block {
    __block SJCarrierInfo *carrierInfo = [SJCarrierInfo new];
    self.carrierInfo = carrierInfo;
    carrierInfo.currentRadioAccessTechnology = ctNetInfo.currentRadioAccessTechnology;
    void (^excute)(CTCarrier *) = ^(CTCarrier *carrier){
        carrierInfo.carrierName = carrier.carrierName;
        carrierInfo.mobileCountryCode = carrier.mobileCountryCode;
        carrierInfo.mobileNetworkCode = carrier.mobileNetworkCode;
        carrierInfo.isoCountryCode = carrier.isoCountryCode;
        carrierInfo.allowsVOIP = carrier.allowsVOIP;
    };
    CTCarrier *carrier = ctNetInfo.subscriberCellularProvider;
    excute(carrier);
    block(carrierInfo);
    ctNetInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
        excute(carrier);// 如果运营商变化将更新运营商输出
        block(carrierInfo);
    };
}

// 监控通话信息
- (void)callState:(void(^)(SJCallInfo *call))block {
    __block SJCallInfo *cInfo = [[SJCallInfo alloc]init];
    callCenter.callEventHandler = ^(CTCall *call) {
        cInfo.callID = call.callID;
        cInfo.callState = SJCallGetCallState(call.callState);
        block(cInfo);
    };
}

// 检测应用中是否有联网权限
// kCTCellularDataRestricted
// kCTCellularDataNotRestricted
// kCTCellularDataRestrictedStateUnknown
- (void)cellularDataState:(void(^)(NSUInteger state))block {
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        block(state);
    };
}




@end

@implementation SJCallInfo
@end

@implementation SJCarrierInfo
@end
