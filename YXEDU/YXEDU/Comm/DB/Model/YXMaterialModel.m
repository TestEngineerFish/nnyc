//
//  YXMaterialModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMaterialModel.h"

@implementation YXMaterialModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.resname forKey:@"resname"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.resid forKey:@"resid"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.resname = [aDecoder decodeObjectForKey:@"resname"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.resid = [aDecoder decodeObjectForKey:@"resid"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}
@end
