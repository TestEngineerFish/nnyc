//
//  NSString+extension.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YR)
- (CGSize)sizeWithConstrainedSize:(CGSize)size font:(UIFont *)font;
- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font;

- (BOOL)isValidHttpOrHttps;

- (BOOL)contains:(NSString*)string;
- (NSString*)add:(NSString*)string;
- (NSDictionary*)firstAndLastName;
- (BOOL)isValidEmail;
- (BOOL)isMobileNumber;
- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
+ (BOOL)isPureInt:(NSString*)string;
- (BOOL)containsOnlyNumbersAndLetters;
- (NSString*)safeSubstringToIndex:(NSUInteger)index;
- (NSString*)stringByRemovingPrefix:(NSString*)prefix;
- (NSString*)stringByRemovingPrefixes:(NSArray*)prefixes;
- (BOOL)hasPrefixes:(NSArray*)prefixes;
- (BOOL)isEqualToOneOf:(NSArray*)strings;
- (NSInteger)lengthOfBytes;
- (BOOL)isChinese;
+ (BOOL)isEmpty:(NSString *) str;

/*
 * 裁剪空字符串
 */
- (NSString *)trimString;
@end
