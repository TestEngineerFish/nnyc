//
//  NSMutableArray+Safe.h
//  YXEDU
//
//  Created by 栗志 on 2018/11/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Safe)

- (void)safeAddObject:(id)object;

@end

NS_ASSUME_NONNULL_END
