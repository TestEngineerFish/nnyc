//
//  YXLearningModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookModel.h"
@implementation YXUnitNameModel

+ (instancetype)modelWithName:(NSString *)name {
    YXUnitNameModel *nameModel = [[YXUnitNameModel alloc]init];
    NSArray *nameArr = [name componentsSeparatedByString:@";"];
    for (int i = 0; i < nameArr.count; i ++) {
        NSString *property = nameArr[i];
        NSArray *propertyArr = [property componentsSeparatedByString:@":"];
        if ([propertyArr.firstObject isEqualToString:@"bgcolor"]) {
            nameModel.bgcolor = propertyArr.lastObject;
        } else if ([propertyArr.firstObject isEqualToString:@"visited"]) {
            nameModel.visited = propertyArr.lastObject;
        } else if ([propertyArr.firstObject isEqualToString:@"line1"]) {
            nameModel.line1 = propertyArr.lastObject;
        } else if ([propertyArr.firstObject isEqualToString:@"line2"]) {
            nameModel.line2 = propertyArr.lastObject;
        }
    }
    return nameModel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bgcolor forKey:@"bgcolor"];
    [aCoder encodeObject:self.visited forKey:@"visited"];
    [aCoder encodeObject:self.line1 forKey:@"line1"];
    [aCoder encodeObject:self.line2 forKey:@"line2"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bgcolor = [aDecoder decodeObjectForKey:@"bgcolor"];
        self.visited = [aDecoder decodeObjectForKey:@"visited"];
        self.line1 = [aDecoder decodeObjectForKey:@"line1"];
        self.line2 = [aDecoder decodeObjectForKey:@"line2"];
    }
    return self;
}
@end

@implementation YXUnitModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.unitid forKey:@"unitid"];
    [aCoder encodeObject:self.word forKey:@"word"];
    [aCoder encodeObject:self.learned forKey:@"learned"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.q_idx forKey:@"q_idx"];
    [aCoder encodeObject:self.learn_status forKey:@"learn_status"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.unitid = [aDecoder decodeObjectForKey:@"unitid"];
        self.word = [aDecoder decodeObjectForKey:@"word"];
        self.learned = [aDecoder decodeObjectForKey:@"learned"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.q_idx = [aDecoder decodeObjectForKey:@"q_idx"];
        self.learn_status = [aDecoder decodeObjectForKey:@"learn_status"];
    }
    return self;
}
@end

@implementation YXBookModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"unit" : [YXUnitModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookid forKey:@"bookid"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.unit forKey:@"unit"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.bookid = [aDecoder decodeObjectForKey:@"bookid"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.unit = [aDecoder decodeObjectForKey:@"unit"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end
