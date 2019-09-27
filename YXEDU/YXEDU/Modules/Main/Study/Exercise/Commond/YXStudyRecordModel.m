//
//  YXStudyRecordModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyRecordModel.h"

@implementation YXStudyRecordModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.recordid forKey:@"recordid"];
    [aCoder encodeObject:self.bookid forKey:@"bookid"];
    [aCoder encodeObject:self.unitid forKey:@"unitid"];
    [aCoder encodeObject:self.questionidx forKey:@"questionidx"];
    [aCoder encodeObject:self.questionid forKey:@"questionid"];
    [aCoder encodeObject:self.learn_status forKey:@"learn_status"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.log forKey:@"log"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.recordid = [aDecoder decodeObjectForKey:@"recordid"];
        self.bookid = [aDecoder decodeObjectForKey:@"bookid"];
        self.unitid = [aDecoder decodeObjectForKey:@"unitid"];
        self.questionidx = [aDecoder decodeObjectForKey:@"questionidx"];
        self.questionid = [aDecoder decodeObjectForKey:@"questionid"];
        self.learn_status = [aDecoder decodeObjectForKey:@"learn_status"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.log = [aDecoder decodeObjectForKey:@"log"];
    }
    return self;
}

@end
