//
//  YXUtils.h
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXUtils : NSObject
+ (NSString *)TempDir;
+ (NSString *)HomeDir;
+ (NSString *)docPath;
// 创建文件
+ (BOOL)createFile:(NSString *)fileName;
// 创建文件目录
+ (BOOL)createFileDir:(NSString *)fileDir;
+ (BOOL)createResourceDir:(NSString *)fileDir;
+ (BOOL)createTmpResourceDir:(NSString *)fileDir;

// 判断文件是否存在
+ (BOOL)fileExist:(NSString *)path;
+ (NSData *)fileContent:(NSString *)path;
+ (BOOL)removeFile:(NSString *)path;
+ (NSData *)fileData:(NSString *)path;

+ (NSString *)resourcePath;
+ (NSString *)resourceTmpPath;

+ (NSString *)findFileAtDir:(NSString *)path ext:(NSString *)ext;

+ (void)showHUD:(UIView *)_view;
+ (void)hideHUD:(UIView *)_view;
+ (void)showHUD:(UIView *)view
          title:(NSString *)text;

+ (void)playRight;
+ (void)playWrong;

+ (NSString *)currentWifiSSID;

+ (void)showProgress:(UIView *)_view;
+ (void)hidenProgress:(UIView *)_view;

+ (void)scanString:(NSString *)scanStr
      resultString:(NSString **)resultStr
     hightlightStr:(NSString **)highStr;

+ (NSString *)fileSizeToString:(unsigned long long)fileSize;

+ (void)screenShot:(UIView *)curView;
+ (NSString *)screenShoutPath;
+ (BOOL)removeScreenShout;
+ (int)randomNumber;
+ (int)getRandomNumber:(int)from
                    to:(int)to;

+ (long long int)numberWithHexString:(NSString *)hexString;

+ (NSString *)getCurTime;

+ (NSString *)machineName;
+ (NSString *)systemVersion;
+ (NSString *)appVersion;
+ (NSString *)carrierName;
+ (NSString *)networkType;
+ (NSString *)screenInch;
+ (NSString *)screenResolution;

+ (NSString *)UUID;
+ (NSString *)filterEmoji:(NSString *)string;
@end
