//
//  SJSignal.h
//  DEMO_project
//
//  Created by shiji on 2016/12/16.
//  Copyright © 2016年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCellularData.h>

typedef NS_ENUM(NSInteger, CTCALL_STATE) {
    SJCallStateDialing,        // 拨号中
    SJCallStateIncoming,       // 正在来电
    SJCallStateDisconnected,   // 断开
    SJCallStateConnected,      // 通话中
};
@class SJCarrierInfo;
@interface SJCallInfo : NSObject
@property (nonatomic, assign) CTCALL_STATE callState;
@property (nonatomic, strong) NSString *callID;

@end

/*Carrier name: [中国移动]
Mobile Country Code: [460]
Mobile Network Code:[02]
ISO Country Code:[cn]
Allows VOIP? [YES]*/

@interface SJCarrierInfo : NSObject
@property (nonatomic, strong) NSString *carrierName;
@property (nonatomic, strong) NSString *mobileCountryCode;
@property (nonatomic, strong) NSString *mobileNetworkCode;
@property (nonatomic, strong) NSString *isoCountryCode;
@property (nonatomic, assign) BOOL allowsVOIP;
@property (nonatomic, strong) NSString *currentRadioAccessTechnology;
@end

@interface SJCall : NSObject
@property (nonatomic, strong, readonly) SJCarrierInfo * carrierInfo;
+ (instancetype)shareInstance;
- (void)carrierInfo:(void(^)(SJCarrierInfo *carrier))block;
- (void)callState:(void(^)(SJCallInfo *call))block;
- (void)cellularDataState:(void(^)(NSUInteger state))block;
@end
