//
//  YXVersionModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXVersionModel.h"
@implementation YXVersionResUpdateModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.flag forKey:@"flag"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.flag = [aDecoder decodeObjectForKey:@"flag"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}
@end

@implementation YXVersionResModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"update" : [YXVersionResUpdateModel class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.update forKey:@"update"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.update = [aDecoder decodeObjectForKey:@"update"];
    }
    return self;
}
@end

@implementation YXVersionModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pf forKey:@"pf"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.channel forKey:@"channel"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.pf = [aDecoder decodeObjectForKey:@"pf"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.channel = [aDecoder decodeObjectForKey:@"channel"];
    }
    return self;
}
@end
