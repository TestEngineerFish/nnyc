//
//  YXUserModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXUserModel_Old.h"

@implementation YXUserModel_Old
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.nick forKey:@"nick"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.user_bind forKey:@"user_bind"];
    [aCoder encodeObject:self.last_login_pf forKey:@"last_login_pf"];
    [aCoder encodeObject:self.learning_book_id forKey:@"learning_book_id"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.nick = [aDecoder decodeObjectForKey:@"nick"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.user_bind = [aDecoder decodeObjectForKey:@"user_bind"];
        self.last_login_pf = [aDecoder decodeObjectForKey:@"last_login_pf"];
        self.learning_book_id = [aDecoder decodeObjectForKey:@"learning_book_id"];
    }
    return self;
}

- (NSString *)area {
    if ([_area containsString:@"，"]) {
        _area = [_area stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    
    return _area;
}
@end
