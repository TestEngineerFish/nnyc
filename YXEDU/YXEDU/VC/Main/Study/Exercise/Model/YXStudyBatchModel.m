//
//  YXStudyBatchModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyBatchModel.h"

@implementation YXStudyBatchDataModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.bookid forKey:@"bookid"];
    [aCoder encodeObject:self.unitid forKey:@"unitid"];
    [aCoder encodeObject:self.questionidx forKey:@"questionidx"];
    [aCoder encodeObject:self.questionid forKey:@"questionid"];
    [aCoder encodeObject:self.learn_status forKey:@"learn_status"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        self.bookid = [aDecoder decodeObjectForKey:@"bookid"];
        self.unitid = [aDecoder decodeObjectForKey:@"unitid"];
        self.questionidx = [aDecoder decodeObjectForKey:@"questionidx"];
        self.questionid = [aDecoder decodeObjectForKey:@"questionid"];
        self.learn_status = [aDecoder decodeObjectForKey:@"learn_status"];
    }
    return self;
}
@end

@implementation YXStudyBatchModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [YXStudyBatchDataModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.learning_log forKey:@"learning_log"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.data = [aDecoder decodeObjectForKey:@"data"];
        self.learning_log = [aDecoder decodeObjectForKey:@"learning_log"];
    }
    return self;
}
@end
