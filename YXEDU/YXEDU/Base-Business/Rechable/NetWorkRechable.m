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

@end
