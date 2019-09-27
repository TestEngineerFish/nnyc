//
//  YXModelArchiverManager.h
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXModelArchiverManager : NSObject
+ (instancetype)shared;
- (BOOL)writeObject:(id)model file:(NSString *)fileName;
- (id)readObject:(NSString *)fileName;
- (void)removeObject:(NSString *)fileName;
- (void)clearAllMemory;
@end
