//
//  UIDevice+YX.h
//  YXEDU
//
//  Created by shiji on 2018/6/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YX)

// 设备名称
- (NSString *)machineName;
// 系统版本
- (NSString *)sysVersion;
// app版本
- (NSString *)appVersion;
//获取联网方式
- (NSString *)networkType;
// 屏幕英寸
- (NSString *)screenInch;
// 屏幕分辨率
- (NSString *)screenResolution;
@end
