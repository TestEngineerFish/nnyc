//
//  YXUtils.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXUtils.h"
#import "NSString+YX.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIDevice+YYAdd.h"
#import "SJCall.h"
#import "BSCommon.h"
#import "UIDevice+YX.h"
#import "YXKeyChain.h"
// #import "AppDelegate.h"
#define RESOURCE @"RESOURCE"
#define TMP @"TMP"

@interface YXUtils () <MBProgressHUDDelegate>

@end

@implementation YXUtils
+ (NSString *)TempDir {
    return NSTemporaryDirectory();
}

+ (NSString *)HomeDir {
    return NSHomeDirectory();
}

+ (NSString *)docPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (BOOL)createFile:(NSString *)fileName {
    return [[NSFileManager defaultManager] createFileAtPath:fileName
                                                   contents:nil
                                                 attributes:nil];
}

+ (BOOL)createFileDir:(NSString *)fileDir {
    if([self fileExist:fileDir]) {
        return YES;
    }
    //如果文件夹不存在，创建文件夹
    NSError *error = nil;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:fileDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error]) {
        return YES;
    }
    //文件夹创建失败
    return NO;
}

+ (BOOL)createResourceDir:(NSString *)fileDir {
    NSString *resPath = [[[self docPath] DIR:RESOURCE] DIR:fileDir];
    return [self createFileDir:resPath];
}

+ (BOOL)createTmpResourceDir:(NSString *)fileDir {
    NSString *resPath = [[[[self docPath] DIR:RESOURCE] DIR:TMP] DIR:fileDir];
    return [self createFileDir:resPath];
}

+ (BOOL)fileExist:(NSString *)path {
    if([[NSFileManager defaultManager] subpathsAtPath:path].count) {
        return YES;
    }
    return NO;
}

+ (NSData *)fileContent:(NSString *)path {
    return [[NSFileManager defaultManager]contentsAtPath:path];
}

+ (BOOL)removeFile:(NSString *)path {
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    if (err) {
        YXLog(@"删除文件失败！");
        return NO;
    }
    return YES;
}

+ (NSString *)resourcePath {
    return [[YXUtils docPath] DIR:RESOURCE];
}

+ (NSString *)resourceTmpPath {
    return [[[YXUtils docPath] DIR:RESOURCE] DIR:TMP];
}

+ (NSData *)fileData:(NSString *)path {
    return [[NSFileManager defaultManager] contentsAtPath:path];
}

+ (NSString *)findFileAtDir:(NSString *)path ext:(NSString *)ext {
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileArray) {
        if ([[fileName pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame) {
            return fileName;
        }
    }
    return nil;
}

#pragma mark - hud
+ (void)showHUD:(UIView *)_view {
    [self showProgress:_view];
}

+ (void)showLoadingInfo:(NSString *)info toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    //当需要消失的时候:
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];
    
    if (info.length) {
        hud.detailsLabel.font = [UIFont systemFontOfSize:14.0f];
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.detailsLabel.text = info;
    }
    hud.margin = 10.f;
    [hud hideAnimated:YES afterDelay:60];
}

+ (void)hideHUD:(UIView *)_view {
    if (!_view) {
        _view = [UIApplication sharedApplication].keyWindow;
    }
    [self hidenProgress:_view];
}

+ (void)showHUD:(UIView *)view title:(NSString *)text {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text         = text;
    hud.detailsLabel.font         = [UIFont systemFontOfSize:14.0f];
    hud.detailsLabel.textColor    = [UIColor whiteColor];
    hud.bezelView.style           = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.margin                    = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}

+ (BOOL)currentHUDForView:(UIView *)view {
    return ([MBProgressHUD HUDForView:view] != nil);
}

+ (void)showProgress:(UIView *)_view {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_view animated:YES];
////    hud.delegate = self;
//    hud.mode = MBProgressHUDModeIndeterminate;
//    //当需要消失的时候:
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    hud.contentColor = [UIColor whiteColor];
//    [hud hideAnimated:YES afterDelay:60];
    [self showProgress:_view info:nil];
}

+ (void)showProgress:(UIView *)view info:(NSString *)info {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];
    if (info) {
        hud.label.text = info;
        hud.label.font = [UIFont systemFontOfSize:14.0f];
    }
//    hud.margin = 10.0;
//    [hud hideAnimated:YES afterDelay:60];
}

+ (void)hidenProgress:(UIView *)_view {
    [MBProgressHUD hideHUDForView:_view animated:YES];
}

+ (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    YXLog(@"ifs:%@",ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        YXLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}

#pragma mark -MBProgressHUDDelegate-
- (void)hudWasHidden:(MBProgressHUD *)hud {
}

+ (void)scanString:(NSString *)scanStr resultString:(NSString **)resultStr hightlightStr:(NSString **)highStr {
    NSString *strLeft = @"<";
    NSString *strRight = @">";
    BOOL scanLeft = YES;
    NSUInteger leftLoc = 0;
    NSUInteger rightLoc = 0;
    NSUInteger span = 0;
    NSMutableString *scanResult = [NSMutableString string];
    NSString *highlightStr = @"";
    [scanResult setString:scanStr];
    NSScanner *scanner = [NSScanner scannerWithString:scanStr];
    while (!scanner.atEnd) {
        if (scanLeft) {
            if ([scanner scanString:strLeft intoString:NULL]) { // 判断第一个字符串
                scanLeft = NO;
                leftLoc = 0;
            } else {
                scanLeft = ![scanner scanUpToString:strLeft intoString:NULL];
                leftLoc = scanner.scanLocation;
            }
            if (!scanLeft) {
                
                if (span && leftLoc != scanStr.length) {
                    highlightStr = [scanStr substringWithRange:NSMakeRange(rightLoc+1, leftLoc-rightLoc-1)];
                }
            }
            
        } else {
            scanLeft = [scanner scanUpToString:strRight intoString:NULL];
            if (scanLeft) {
                rightLoc = scanner.scanLocation;
                [scanResult replaceCharactersInRange:NSMakeRange(leftLoc-span, rightLoc-leftLoc+1) withString:@""];
                span = rightLoc-leftLoc+1;
            }
        }
    }
    *highStr = highlightStr;
    *resultStr = scanResult;
}

// format memory size
+ (NSString *)fileSizeToString:(unsigned long long)fileSize {
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    if (fileSize < 10) return @"0 B";
    else if (fileSize < KB) return @"< 1 KB";
    else if (fileSize < MB) return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
    else if (fileSize < GB) return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
    else return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
}

+ (void)screenShot:(UIView *)curView {
    //这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，iPadHeight为768，
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);//设置截屏大小
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0);//设置截屏大小
    [[curView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef =viewImage.CGImage;
    CGRect rect = [UIScreen mainScreen].bounds;//这里可以设置想要截图的区域
    rect.size.height = 4 *rect.size.height;
    rect.size.width = 4 *rect.size.width;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage =[[UIImage alloc] initWithCGImage:imageRefRect];
//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    NSData *imageViewData =UIImagePNGRepresentation(sendImage);
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"ScreenShout.png"];
    NSString *savedImagePath =[documentsDirectory stringByAppendingPathComponent:pictureName];
    YXLog(@"截屏路径打印: %@", savedImagePath);
    //这里我将路径设置为一个全局String，这里做的不好，我自己是为了用而已，希望大家别这么写
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
}

+ (UIImage *)screenShot {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), YES, 0);
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (NSString *)screenShoutPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"ScreenShout.png"];
}

+ (BOOL)removeScreenShout {
    NSError *error = nil;
    [[NSFileManager defaultManager]removeItemAtPath:[self screenShoutPath] error:&error];
    if (error) {
        YXLog(@"%@", error.description);
        return NO;
    }
    return YES;
}

+ (int)randomNumber {
    return [self getRandomNumber:100000 to:9999999];
}

+ (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + arc4random() % (to-from + 1)); //+1,result is [from to]; else is [from, to)!!!!!!!
}

+ (long long int)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (long long int)hexNumber;
}

+ (NSString *)getCurTime {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger hour      = [components hour];
    NSInteger minute    = [components minute];
    NSInteger monty = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    NSInteger sec = [components second];
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)year,(long)monty,(long)day,(long)hour,(long)minute,(long)sec];
}

+ (NSString *)machineName {
    return [[UIDevice currentDevice]machineName];
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice]sysVersion];
}

+ (NSString *)appVersion {
    return [NSString stringWithFormat:@"V%@", [[UIDevice currentDevice] appVersion]];
}

+ (NSString *)carrierName {
    return [SJCall shareInstance].carrierInfo.carrierName;
}

//获取联网方式
+ (NSString *)networkType {
    return [[UIDevice currentDevice]networkType];
}

+ (NSString *)screenInch {
    return [[UIDevice currentDevice]screenInch];
}

+ (NSString *)screenResolution {
    return [[UIDevice currentDevice] screenResolution];
}

// UUID
+ (NSString *)UUID {
    NSData *UUIDData = [YXKeyChain load:@"com.yx.cn"];
    if (!UUIDData) {
        NSString *UUID = [NSString createCUID:@"YX"];
        UUIDData = [UUID dataUsingEncoding:NSUTF8StringEncoding];
        [YXKeyChain save:@"com.yx.cn" data:UUIDData];
    }
    return [[NSString alloc]initWithData:UUIDData encoding:NSUTF8StringEncoding];
}

//过滤表情
+ (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = (unsigned int)utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

+ (NSString *)formatDateStr:(NSString *)yyMMdd {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // NSString * -> NSDate *
    NSDate *date = [fmt dateFromString:yyMMdd];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM.dd";
    return [formatter stringFromDate:date];
}

+ (NSString *)fresherGuideKey {
    NSString *key = [NSString stringWithFormat:@"k%@-fresherGuideKey",[[UIDevice currentDevice] appVersion]];
    return key;
}
@end
