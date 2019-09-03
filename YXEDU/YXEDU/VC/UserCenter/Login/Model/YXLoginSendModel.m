//
//  YXLoginSendModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLoginSendModel.h"

@implementation YXLoginSendModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pf forKey:@"pf"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.openid forKey:@"openid"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.pf = [aDecoder decodeObjectForKey:@"pf"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.openid = [aDecoder decodeObjectForKey:@"openid"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}
@end
