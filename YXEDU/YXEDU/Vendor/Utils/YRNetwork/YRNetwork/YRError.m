//
//  YRError.m
//  pyyx
//
//  Created by Chunlin Ma on 15/5/4.
//  Copyright (c) 2015年 PengYouYinXing. All rights reserved.
//

#import "YRError.h"

@implementation YRError

+ (id)errorWithCode:(NSInteger)code desc:(NSString *)desc {
    return [self errorWithCode:code desc:desc warningDesc:nil];
}

+ (id)errorWithCode:(NSInteger)code desc:(NSString *)desc warningDesc:(NSString *)warningDesc {
    YRError *error = [[YRError alloc] init];
    error.code = code;
    error.desc = desc;
    error.warningDesc = warningDesc;
    return error;
}

@end
