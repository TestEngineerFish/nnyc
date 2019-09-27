//
//  YXReportModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXReportDeviceModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *devices_id;
@property (nonatomic, strong) NSString *jp_devices_id;
@property (nonatomic, strong) NSString *jp_registration_id;
@end
