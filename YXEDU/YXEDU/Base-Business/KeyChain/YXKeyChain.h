//
//  YXKeyChain.h
//  YXEDU
//
//  Created by shiji on 2018/6/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXKeyChain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
@end
