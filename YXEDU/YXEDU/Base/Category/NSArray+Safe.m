//
//  NSArray+Safe.m
//  YXEDU
//
//  Created by 栗志 on 2018/11/19.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

@end
