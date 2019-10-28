//
//  NSObject+YR.m
//  YRUtils
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "NSObject+YR.h"
#import "YXModel.h"

@implementation NSObject (YR)

+ (id)yrModelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

- (NSString *)yrModelToJSONString {
    return [self yy_modelToJSONString];
}

- (id)yrModelToDictionary {
    return [self yy_modelToJSONObject];
}

@end
