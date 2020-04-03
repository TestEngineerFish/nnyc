//
//  YXInterfaceCacheService.m
//  YXEDU
//
//  Created by shiji on 2018/6/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXInterfaceCacheService.h"
#import "YXModelArchiverManager.h"
#import "YXConfigure.h"
#import "YXAPI.h"

@interface YXInterfaceCacheService ()

@end

@implementation YXInterfaceCacheService
+ (instancetype)shared {
    static YXInterfaceCacheService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXInterfaceCacheService new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)read:(NSString *)key {
    return [[YXModelArchiverManager shared]readObject:key];
}

- (void)write:(id)obj key:(NSString *)key {
    if (obj != nil) {
        [[YXModelArchiverManager shared]writeObject:obj file:key];
    }
}

- (void)remove:(NSString *)key {
    [[YXModelArchiverManager shared]removeObject:key];
}
@end
