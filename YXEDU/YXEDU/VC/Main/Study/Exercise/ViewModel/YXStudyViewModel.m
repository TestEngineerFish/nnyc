//
//  YXStudyViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyViewModel.h"
#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YX_URL.h"


@interface YXStudyViewModel ()

@end

@implementation YXStudyViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 上报学习进度
- (void)reportStudyProgress:(YXStudyProgressModel *)model
                     finish:(finishBlock)block {
    NSDictionary *dic = [model yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_STUDY parameters:dic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)batchReportStudy:(YXStudyBatchModel *)model finish:(finishBlock)block {
    NSDictionary *dic = [model yrModelToDictionary];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSData *data = [NSJSONSerialization dataWithJSONObject:mutableDic[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
    [mutableDic setObject:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] forKey:@"data"];
    NSData *learning_logData = [NSJSONSerialization dataWithJSONObject:mutableDic[@"learning_log"] options:NSJSONWritingPrettyPrinted error:nil];
    [mutableDic setObject:[[NSString alloc]initWithData:learning_logData encoding:NSUTF8StringEncoding] forKey:@"learning_log"];
    [[YXHttpService shared]POST:DOMAIN_BATCH parameters:mutableDic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

-(NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
