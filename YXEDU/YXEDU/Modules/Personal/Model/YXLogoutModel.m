//
//  YXLogoutModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLogoutModel.h"

@implementation YXLogoutModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.jp_devices_id forKey:@"jp_devices_id"];
    [aCoder encodeObject:self.jp_registration_id forKey:@"jp_registration_id"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.jp_devices_id = [aDecoder decodeObjectForKey:@"jp_devices_id"];
        self.jp_registration_id = [aDecoder decodeObjectForKey:@"jp_registration_id"];
    }
    return self;
}
@end
