//
//  YXPersonalDelModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/21.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBookDelModel.h"

@implementation YXPersonalBookDelModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookids forKey:@"bookids"];
    [aCoder encodeObject:self.reset forKey:@"reset"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bookids = [aDecoder decodeObjectForKey:@"bookids"];
        self.reset = [aDecoder decodeObjectForKey:@"reset"];
    }
    return self;
}
@end
