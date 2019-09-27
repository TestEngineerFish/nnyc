//
//  YXStudyBookUnitModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyBookUnitModel.h"

@implementation YXStudyBookUnitTopicModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.question_id forKey:@"question_id"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
    [aCoder encodeObject:self.tip forKey:@"tip"];
    [aCoder encodeObject:self.options forKey:@"options"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
        self.question_id = [aDecoder decodeObjectForKey:@"question_id"];
        self.tip = [aDecoder decodeObjectForKey:@"tip"];
        self.options = [aDecoder decodeObjectForKey:@"options"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}
@end

@implementation YXStudyBookUnitInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"topic" : [YXStudyBookUnitTopicModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.confusion forKey:@"confusion"];
    [aCoder encodeObject:self.eng forKey:@"eng"];
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.paraphrase forKey:@"paraphrase"];
    [aCoder encodeObject:self.property forKey:@"property"];
    [aCoder encodeObject:self.topic forKey:@"topic"];
    [aCoder encodeObject:self.ukvoice forKey:@"ukvoice"];
    [aCoder encodeObject:self.usvoice forKey:@"usvoice"];
    [aCoder encodeObject:self.word forKey:@"word"];
    [aCoder encodeObject:self.wordid forKey:@"wordid"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.confusion = [aDecoder decodeObjectForKey:@"confusion"];
        self.eng = [aDecoder decodeObjectForKey:@"eng"];
        self.chs = [aDecoder decodeObjectForKey:@"chs"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.paraphrase = [aDecoder decodeObjectForKey:@"paraphrase"];
        self.property = [aDecoder decodeObjectForKey:@"property"];
        self.topic = [aDecoder decodeObjectForKey:@"topic"];
        self.ukvoice = [aDecoder decodeObjectForKey:@"ukvoice"];
        self.usvoice = [aDecoder decodeObjectForKey:@"usvoice"];
        self.word = [aDecoder decodeObjectForKey:@"word"];
        self.wordid = [aDecoder decodeObjectForKey:@"wordid"];
    }
    return self;
}
@end

@implementation YXStudyBookUnitModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"unitinfo" : [YXStudyBookUnitInfoModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bookid forKey:@"bookid"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
    [aCoder encodeObject:self.filename forKey:@"filename"];
    [aCoder encodeObject:self.unitid forKey:@"unitid"];
    [aCoder encodeObject:self.group forKey:@"group"];
    [aCoder encodeObject:self.group_word_count forKey:@"group_word_count"];
    [aCoder encodeObject:self.unitinfo forKey:@"unitinfo"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bookid = [aDecoder decodeObjectForKey:@"bookid"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
        self.filename = [aDecoder decodeObjectForKey:@"filename"];
        self.unitid = [aDecoder decodeObjectForKey:@"unitid"];
        self.group = [aDecoder decodeObjectForKey:@"group"];
        self.group_word_count = [aDecoder decodeObjectForKey:@"group_word_count"];
        self.unitinfo = [aDecoder decodeObjectForKey:@"unitinfo"];
    }
    return self;
}
@end
