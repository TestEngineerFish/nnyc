//
//  NSDictionary+addition.m
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "NSDictionary+YR.h"

@implementation NSDictionary (YR)

- (NSString *)dictionaryToJsonString {
    return [self formatToJSON];
}

- (NSString *)formatToJSON {
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (id)filterNullObject {
    return [self filterNullObject:YES];
}

- (id)filterNullObject:(BOOL)allowNilResult {
    NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in [self allKeys]) {
        id value = [self objectForKey:key];
        value = [value filterNullObject];
        if (value) {
            [filterDictionary setObject:value forKey:key];
        }
    }
    return allowNilResult ? ([filterDictionary count] ? filterDictionary : nil) : filterDictionary;
}

- (id)filterEmptyString {
    return [self filterEmptyString:YES];
}

- (id)filterEmptyString:(BOOL)allowNilResult {
    NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in [self allKeys]) {
        id value = [self objectForKey:key];
        value = [value filterEmptyString];
        if (value) {
            [filterDictionary setObject:value forKey:key];
        }
    }
    return allowNilResult ? ([filterDictionary count] ? filterDictionary : nil) : filterDictionary;
}

@end
