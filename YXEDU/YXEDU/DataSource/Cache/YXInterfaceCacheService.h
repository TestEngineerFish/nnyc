//
//  YXInterfaceCacheService.h
//  YXEDU
//
//  Created by shiji on 2018/6/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGetUserInfo @"getinfo" // login
#define kGetBookList @"getbooklist" // 获取图书列表

@interface YXInterfaceCacheService : NSObject
+ (instancetype)shared;
- (id)read:(NSString *)key;
- (void)write:(id)obj key:(NSString *)key;
- (void)remove:(NSString *)key;
@end
