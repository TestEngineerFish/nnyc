//
//  YXPersonalBookModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBookModel.h"


@implementation YXPersonalBookModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"booklist" : [YXBookModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.booklist forKey:@"booklist"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.booklist = [aDecoder decodeObjectForKey:@"booklist"];
    }
    return self;
}
@end
