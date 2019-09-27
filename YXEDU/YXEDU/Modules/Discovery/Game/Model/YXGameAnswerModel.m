//
//  YXGameAnswerModel.m
//  YXEDU
//
//  Created by yao on 2019/1/3.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameAnswerModel.h"

//@implementation YXGameAnswer
//@end

@implementation YXGameAnswerModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"gameContent" : [YXGameAnswer class]
             };
}
@end
