//
//  YXSendSMSModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSendSMSModel.h"

@implementation YXSendSMSModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.captcha forKey:@"captcha"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.captcha = [aDecoder decodeObjectForKey:@"captcha"];
    }
    return self;
}
@end
