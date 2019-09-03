//
//  YXReportModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportDeviceModel.h"

@implementation YXReportDeviceModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.ssid forKey:@"ssid"];
    [aCoder encodeObject:self.os forKey:@"os"];
    [aCoder encodeObject:self.devices_id forKey:@"devices_id"];
    [aCoder encodeObject:self.jp_devices_id forKey:@"jp_devices_id"];
    [aCoder encodeObject:self.jp_registration_id forKey:@"jp_registration_id"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.ssid = [aDecoder decodeObjectForKey:@"ssid"];
        self.os = [aDecoder decodeObjectForKey:@"os"];
        self.devices_id = [aDecoder decodeObjectForKey:@"devices_id"];
        self.jp_devices_id = [aDecoder decodeObjectForKey:@"jp_devices_id"];
        self.jp_registration_id = [aDecoder decodeObjectForKey:@"jp_registration_id"];
    }
    return self;
}
@end
