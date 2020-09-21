//
//  YRDevice.m
//  pyyx
//
//  Created by Chunlin Ma on 16/7/11.
//  Copyright © 2016年 朋友印象. All rights reserved.
//

#import "YRDevice.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
#import <objc/runtime.h>

NSString * const SSKeychainService = @"service";
NSString * const SSKeychainOpenUDIDKey = @"udid";

@implementation YRDevice

+ (NSString *)OSVersion
{
    NSString *OSVersion = [NSString stringWithFormat:@"iOS %f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    return OSVersion;
}

+ (NSString *)appVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    
#ifdef TARGET_ZXPY
    return @"3.4.4";
#endif
    return versionNum;
}

+ (NSString *)appBuild {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* build =[infoDict objectForKey:@"CFBundleVersion"];
    return build;
}

+ (NSString*) modelVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

@end
