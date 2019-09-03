//
//  YXFileDBManager.h
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXFileDBManager : NSObject
+ (instancetype)shared;
- (BOOL)unitFileIsExist:(NSString *)name;
- (void)unzipFile:(NSString *)name;
- (BOOL)removeZipFile:(NSString *)name;
@end
