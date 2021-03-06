//
//  UIDevice+YX.m
//  YXEDU
//
//  Created by shiji on 2018/6/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIDevice+YX.h"
#include <sys/sysctl.h>
#import <Reachability/Reachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation UIDevice (YX)

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

// 设备名称
- (NSString *)machineName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
            // iWatch
            @"Watch1,1" : @"Apple Watch 38mm",
            @"Watch1,2" : @"Apple Watch 42mm",
            @"Watch2,3" : @"Apple Watch Series 2 38mm",
            @"Watch2,4" : @"Apple Watch Series 2 42mm",
            @"Watch2,6" : @"Apple Watch Series 1 38mm",
            @"Watch1,7" : @"Apple Watch Series 1 42mm",
            // iPod touch
            @"iPod1,1" : @"iPod touch 1",
            @"iPod2,1" : @"iPod touch 2",
            @"iPod3,1" : @"iPod touch 3",
            @"iPod4,1" : @"iPod touch 4",
            @"iPod5,1" : @"iPod touch 5",
            @"iPod7,1" : @"iPod touch 6",
            // iPhone
            @"iPhone1,1"  : @"iPhone 1G",
            @"iPhone1,2"  : @"iPhone 3G",
            @"iPhone2,1"  : @"iPhone 3GS",
            @"iPhone3,1"  : @"iPhone 4 (GSM)",
            @"iPhone3,2"  : @"iPhone 4",
            @"iPhone3,3"  : @"iPhone 4 (CDMA)",
            @"iPhone4,1"  : @"iPhone 4S",
            @"iPhone5,1"  : @"iPhone 5",
            @"iPhone5,2"  : @"iPhone 5",
            @"iPhone5,3"  : @"iPhone 5c",
            @"iPhone5,4"  : @"iPhone 5c",
            @"iPhone6,1"  : @"iPhone 5s",
            @"iPhone6,2"  : @"iPhone 5s",
            @"iPhone7,1"  : @"iPhone 6 Plus",
            @"iPhone7,2"  : @"iPhone 6",
            @"iPhone8,1"  : @"iPhone 6s",
            @"iPhone8,2"  : @"iPhone 6s Plus",
            @"iPhone8,4"  : @"iPhone SE",
            @"iPhone9,1"  : @"iPhone 7",
            @"iPhone9,2"  : @"iPhone 7 Plus",
            @"iPhone9,3"  : @"iPhone 7",
            @"iPhone9,4"  : @"iPhone 7 Plus",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X",
            @"iPhone10,6" : @"iPhone X",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,4" : @"iPhone XS Max",
            @"iPhone11,6" : @"iPhone XS Max",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            @"iPhone12,8" : @"iPhone SE 2",
            // iPad
            @"iPad1,1" : @"iPad 1",
            @"iPad2,1" : @"iPad 2 (WiFi)",
            @"iPad2,2" : @"iPad 2 (GSM)",
            @"iPad2,3" : @"iPad 2 (CDMA)",
            @"iPad2,4" : @"iPad 2",
            @"iPad2,5" : @"iPad mini 1",
            @"iPad2,6" : @"iPad mini 1",
            @"iPad2,7" : @"iPad mini 1",
            @"iPad3,1" : @"iPad 3 (WiFi)",
            @"iPad3,2" : @"iPad 3 (4G)",
            @"iPad3,3" : @"iPad 3 (4G)",
            @"iPad3,4" : @"iPad 4",
            @"iPad3,5" : @"iPad 4",
            @"iPad3,6" : @"iPad 4",
            @"iPad6,11" : @"iPad 5",
            @"iPad6,12" : @"iPad 5",
            // iPad Air
            @"iPad4,1" : @"iPad Air",
            @"iPad4,2" : @"iPad Air",
            @"iPad4,3" : @"iPad Air",
            @"iPad5,3" : @"iPad Air 2",
            @"iPad5,4" : @"iPad Air 2",
            // iPad mini
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad mini 4",
            @"iPad5,2" : @"iPad mini 4",
            // iPad Pro
            @"iPad6,3" : @"iPad Pro (9.7 inch)",
            @"iPad6,4" : @"iPad Pro (9.7 inch)",
            @"iPad6,7" : @"iPad Pro (12.9 inch)",
            @"iPad6,8" : @"iPad Pro (12.9 inch)",
            @"iPad7,1" : @"iPad Pro (12.9 inch 2)",
            @"iPad7,2" : @"iPad Pro (12.9 inch 2)",
            @"iPad7,3" : @"iPad Pro (10.5 inch)",
            @"iPad7,4" : @"iPad Pro (10.5 inch)",
            // iTV
            @"AppleTV2,1" : @"Apple TV 2",
            @"AppleTV3,1" : @"Apple TV 3",
            @"AppleTV3,2" : @"Apple TV 3",
            @"AppleTV5,3" : @"Apple TV 4",
            // Simulator
            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
        };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

// 系统版本
- (NSString *)sysVersion {
    return [self systemVersion];
}

// app版本
- (NSString *)appVersion {
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}


////获取联网方式
- (NSString *)networkType {
    NSString *network = @"";
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus curNetStatus = [reachability currentReachabilityStatus];
    switch (curNetStatus) {
        case ReachableViaWiFi:
            network = @"WIFI";
            break;
        case ReachableViaWWAN:
            network = [self getNetType];
            break;
        case NotReachable:
            network = @"NONE";
        default:
            break;
    }
    
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

- (NSString *)getNetType {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) { //ios7 以上
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
        if (currentRadioAccessTechnology) {
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                return @"4G";//retVal = ReachableVia4G;
            } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                return @"2G";//retVal = ReachableVia2G;
            } else {
                return @"3G";//retVal = ReachableVia3G;
            }
        }else {
            return @"";
        }
    }else {
        return @"";
    }
}

// 屏幕英寸
- (NSString *)screenInch {
    static dispatch_once_t onceToken;
    static NSString *screenName;
    dispatch_once(&onceToken, ^{
        NSString *machineName = [self machineName];
        NSDictionary *dic = @{
            @"iPhone 4S"        :@"3.5",
            @"iPhone 5"         :@"4",
            @"iPhone 5c"        :@"4",
            @"iPhone 5s"        :@"4",
            @"iPhone 6 Plus"    :@"5.5",
            @"iPhone 6"         :@"4.7",
            @"iPhone 6s"        :@"4.7",
            @"iPhone 6s Plus"   :@"5.5",
            @"iPhone SE"        :@"4",
            @"iPhone 7"         :@"4.7",
            @"iPhone 7 Plus"    :@"5.5",
            @"iPhone 8"         :@"4.7",
            @"iPhone 8 Plus"    :@"5.5",
            @"iPhone X"         :@"5.8",
            @"iPhone XS"        :@"5.8",
            @"iPhone XS Max"    :@"6.5",
            @"iPhone XR"        :@"6.1",
            @"iPhone 11"        :@"6.1",
            @"iPhone 11 Pro"    :@"5.8",
            @"iPhone 11 Pro Max":@"6.5",
            @"iPhone SE 2"      :@"4.7",
        };
        screenName = dic[machineName];
        if (screenName == nil) {
            screenName = @"undefined";
        }
    });
    return screenName;
}

// 屏幕分辨率
- (NSString *)screenResolution {
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    int width = size_screen.width*scale_screen;
    int height = size_screen.height*scale_screen;
    return [NSString stringWithFormat:@"%dx%d", width, height];
}
@end
