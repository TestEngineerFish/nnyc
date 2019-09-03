//
//  YXConfigure3Model.m
//  YXEDU
//
//  Created by shiji on 2018/6/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXConfigure3Model.h"

@implementation YXConfigure3BookModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.book_id forKey:@"book_id"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.word_count forKey:@"word_count"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.book_id = [aDecoder decodeObjectForKey:@"book_id"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.word_count = [aDecoder decodeObjectForKey:@"word_count"];
    }
    return self;
}

@end

@implementation YXConfigure3GradeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"options" : [YXConfigure3BookModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.options forKey:@"config"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.options = [aDecoder decodeObjectForKey:@"options"];
    }
    return self;
}

@end

@implementation YXConfigure3Model
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"config" : [YXConfigure3GradeModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.config forKey:@"config"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.config = [aDecoder decodeObjectForKey:@"config"];
    }
    return self;
}

@end
