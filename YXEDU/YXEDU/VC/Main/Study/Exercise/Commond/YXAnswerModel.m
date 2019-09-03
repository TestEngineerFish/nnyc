//
//  YXCmdModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXAnswerModel.h"

@implementation YXAnswerModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
    }
    return self;
}
@end
