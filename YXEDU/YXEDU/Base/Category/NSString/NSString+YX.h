//
//  NSString+FV.h
//  FunVideo
//
//  Created by shiji on 2018/1/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FILE_T){
    T_ZIP,
    T_JPG,
    T_MP4,
    T_MOV,
    T_PLIST,
    T_MP3
};

@interface NSString (YX)
- (NSString *)DIR:(NSString *)dir;
- (NSString *)stringAppendType:(FILE_T)type;
+ (NSString *)EXT:(FILE_T)type;
- (BOOL)MobileNumber;
+ (NSString *)createCUID:(NSString *)prefix;

- (NSNumber *)transitionNumber;
// 转换成带有阴影的SttributedString
- (NSAttributedString *)convertAttributeString;

- (NSMutableDictionary *)getURLParameters;
- (unsigned int)conversionToHex;
-(NSString *)getMinuteFromSecond;
-(NSString *)getHourFromSecond;
@end
