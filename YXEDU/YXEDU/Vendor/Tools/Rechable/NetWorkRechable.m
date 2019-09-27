//
//  NetWorkRechable.m
//  YXEDU
//
//  Created by shiji on 2018/4/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "NetWorkRechable.h"
#import "AFNetworkReachabilityManager.h"

@interface NetWorkRechable ()

@end

@implementation NetWorkRechable
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [self realTimeMonitoringNetWork];
    }
    return self;
}

+ (instancetype)shared {
    static NetWorkRechable *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{   //
        shared = [NetWorkRechable new];
    });
    return shared;
}
- (void)realTimeMonitoringNetWork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
            case AFNetworkReachabilityStatusUnknown:
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [kNotificationCenter postNotificationName:kOffNetworkNotify object:nil userInfo:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [kNotificationCenter postNotificationName:kNetworkConnectedNotify object:nil userInfo:nil];
                break;
            default:
                break;
        }
    }];
}

- (NetWorkStatus)netWorkStatus {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return NetWorkStatusUnknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return NetWorkStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NetWorkStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NetWorkStatusReachableViaWiFi;
            break;
        default:
            return NetWorkStatusUnknown;
            break;
    }
}

- (BOOL)connected {
    NetWorkStatus status = self.netWorkStatus;
    return (status == NetWorkStatusReachableViaWWAN) || (status == NetWorkStatusReachableViaWiFi);
    
}
@end
