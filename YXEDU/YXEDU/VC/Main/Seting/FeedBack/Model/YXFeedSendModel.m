//
//  YXFeedSendModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFeedSendModel.h"

@implementation YXFeedSendModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.feed forKey:@"feed"];
    [aCoder encodeObject:self.env forKey:@"env"];
    [aCoder encodeObject:self.files forKey:@"files"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.feed = [aDecoder decodeObjectForKey:@"feed"];
        self.env = [aDecoder decodeObjectForKey:@"env"];
        self.files = [aDecoder decodeObjectForKey:@"files"];
    }
    return self;
}
@end
