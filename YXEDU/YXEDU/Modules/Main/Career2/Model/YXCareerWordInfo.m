//
//  YXCareerWordInfo.m
//  YXEDU
//
//  Created by yao on 2018/10/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCareerWordInfo.h"
#import "YXWordModelManager.h"
@implementation YXCareerWordInfo
- (NSString *)dateStr {
    if (!_dateStr) {
        NSTimeInterval interval = self.createdAt;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        _dateStr = dateStr ? dateStr : @"";
    }
    return _dateStr;
}

- (void)quaryWordDetail:(WordDetailBlock)wordDetailBlock {
    [YXWordModelManager quardWithWordIds:@[self.wordId] completeBlock:^(id obj, BOOL result) {
        if (result) {
            NSArray *results = obj;
            _wordDetail = results.firstObject;
            wordDetailBlock(results.firstObject);
        }
    }];
}


@end
