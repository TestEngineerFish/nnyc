//
//  YXStudyProgressModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyProgressModel.h"

@implementation YXStudyProgressModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bookid forKey:@"bookid"];
    [aCoder encodeObject:self.unitid forKey:@"unitid"];
    [aCoder encodeObject:self.wordid forKey:@"wordid"];
    [aCoder encodeObject:self.questionid forKey:@"questionid"];
    [aCoder encodeObject:self.answer forKey:@"answer"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bookid = [aDecoder decodeObjectForKey:@"bookid"];
        self.unitid = [aDecoder decodeObjectForKey:@"unitid"];
        self.wordid = [aDecoder decodeObjectForKey:@"wordid"];
        self.questionid = [aDecoder decodeObjectForKey:@"questionid"];
        self.answer = [aDecoder decodeObjectForKey:@"answer"];
    }
    return self;
}
@end
