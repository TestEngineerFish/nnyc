//
//  YXBindModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBindModel.h"

@implementation YXBindModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}
@end
