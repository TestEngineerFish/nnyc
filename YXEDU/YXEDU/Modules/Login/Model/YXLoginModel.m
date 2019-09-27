//
//  YXLoginModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLoginModel.h"

@implementation YXLoginModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.learning forKey:@"learning"];
    [aCoder encodeObject:self.booklist forKey:@"booklist"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.learning = [aDecoder decodeObjectForKey:@"learning"];
        self.booklist = [aDecoder decodeObjectForKey:@"booklist"];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"booklist" : [YXBookModel class] };
}

@end
