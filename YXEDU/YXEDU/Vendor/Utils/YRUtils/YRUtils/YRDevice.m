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
#import <SSKeychain/SSKeychain.h>

NSString * const SSKeychainService = @"service";
NSString * const SSKeychainOpenUDIDKey = @"udid";

@interface SSKeychain (Utils)
+ (NSString *)openUDID;
+ (void)setOpenUDID:(NSString *)openUDID;
@end

@implementation SSKeychain (Utils)

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)openUDIDGenernalKey {
    return [NSString stringWithFormat:@"%@ - %@", [self bundleName], SSKeychainOpenUDIDKey];
}

+ (NSString *)openUDID {
    NSError *error = nil;
    NSString *opendUDID = [self passwordForService:SSKeychainService account:[self openUDIDGenernalKey] error:&error];
    if (error) {
        
    }
    return opendUDID;
}


+ (void)setOpenUDID:(NSString *)openUDID {
    [self setPassword:openUDID forService:SSKeychainService account:[self openUDIDGenernalKey]];
}

@end


@implementation YRDevice

+ (NSString *)openUDID {
    NSString *localOpenUDID = [SSKeychain openUDID];
    if ([localOpenUDID length]) {
        return localOpenUDID;
    }
    unsigned char result[16];
    const char *cStr = [[[NSProcessInfo processInfo] globallyUniqueString] UTF8String];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *udid = [NSString stringWithFormat:
                      @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15],
                      arc4random() % 4294967295];
    
    SSKeychain.openUDID = udid;
    return udid;
}

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
