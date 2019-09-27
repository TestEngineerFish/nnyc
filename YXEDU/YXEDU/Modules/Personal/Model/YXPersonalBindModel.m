//
//  YXPersonalBindModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBindModel.h"

@implementation YXPersonalBindModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bind_pf forKey:@"bind_pf"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.openid forKey:@"openid"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bind_pf = [aDecoder decodeObjectForKey:@"bind_pf"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.openid = [aDecoder decodeObjectForKey:@"openid"];
    }
    return self;
}

@end
