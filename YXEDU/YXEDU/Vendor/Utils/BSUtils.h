

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BSUtils : NSObject
+ (NSString *)systemName;
+ (NSString *)systemVersion;
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDate *)formatToDate:(NSString *)strDate;

/**
 检查手机号码是否有效
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 检查身份证号码是否为有效
 */
+ (BOOL)isIDCardNumberCorrect:(NSString *)IDCardNumber;

/**
 检查邮箱地址是否有效
 */
+ (BOOL)isEmailAddress:(NSString*)email;


/**
 检查是否为纯汉字
 
 @param realname 字符串参数
 @return 是否
 */
+ (BOOL)isValidateChinaChar:(NSString *)realname;

//判断字符串空
+ (BOOL)isBlankString:(NSString *)aStr;

// 将JSON串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
