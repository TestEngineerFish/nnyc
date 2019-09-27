//
//  NSArray+additions.m
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "NSArray+YR.h"

@implementation NSArray (YR)
- (id)filterNullObject {
    return [self filterNullObject:YES];
}

- (id)filterNullObject:(BOOL)allowNilResult {
    NSMutableArray *filterArray = [NSMutableArray array];
    for (id value in self) {
        id filterValue = [value filterNullObject];
        if (filterValue) {
            [filterArray addObject:filterValue];
        }
    }
    return allowNilResult ? ([filterArray count] ? filterArray : nil) : filterArray;
}

- (id)filterEmptyString {
    return [self filterEmptyString:YES];
}

- (id)filterEmptyString:(BOOL)allowNilResult {
    NSMutableArray *filterArray = [NSMutableArray array];
    for (id value in self) {
        id filterValue = [value filterEmptyString];
        if (filterValue) {
            [filterArray addObject:filterValue];
        }
    }
    return allowNilResult ? ([filterArray count] ? filterArray : nil) : filterArray;
}

@end
