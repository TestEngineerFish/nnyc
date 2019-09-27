//
//  JPushManager.h
//  YXEDU
//
//  Created by shiji on 2018/4/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushManager : NSObject
+ (instancetype)shared;
- (void)registerJPush:(NSString *)appKey;
- (void)registerDeviceToken:(NSData *)deviceToken;
@end
