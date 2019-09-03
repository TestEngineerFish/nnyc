//
//  NetWorkRechable.h
//  YXEDU
//
//  Created by shiji on 2018/4/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusUnknown,        //
    NetWorkStatusNotReachable,
    NetWorkStatusReachableViaWWAN,
    NetWorkStatusReachableViaWiFi,
};

@interface NetWorkRechable : NSObject
+ (instancetype)shared;
@property (nonatomic, assign) NetWorkStatus netWorkStatus;
@end
