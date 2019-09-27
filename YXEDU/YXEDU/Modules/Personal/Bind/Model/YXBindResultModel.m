//
//  YXBindResultModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBindResultModel.h"

@implementation YXBindResultMobileModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
}
@end

@implementation YXBindResultModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bindmobile" : [YXBindResultMobileModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bindmobile forKey:@"bindmobile"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bindmobile = [aDecoder decodeObjectForKey:@"bindmobile"];
    }
    return self;
}
@end
