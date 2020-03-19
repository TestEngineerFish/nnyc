
//DEPRECATED_MSG_ATTRIBUTE("Use baz: method instead.");

#ifndef XSGCommon_h
#define XSGCommon_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif /* XSGCommon_h */

// 375x667  414x736  750x1624
#define kIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) : NO)
#define kIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)?YES:(([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO))) : NO)


#define kIsIPhone_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsIPhone_XS kIsIPhone_X
#define kIsIPhone_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsIPhone_XMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIsIPhoneXSerious isIPhoneXSerious()
/** before v1.3.0 */
//#define  kStatusBarHeight (iPhoneX ? 44.f : 20.f)
/** before v1.3.0 */
//#define  kNavHeight  (iPhoneX ? 88.f : 64.f)
/** before v1.3.0 */
//#define  kSafeBottomMargin (iPhoneX ? 34.f : 0.f)
#define  kStatusBarHeight (kIsIPhoneXSerious ? 44.f : 20.f)
#define  kNavHeight  (kStatusBarHeight + 44)
#define  kSafeBottomMargin (kIsIPhoneXSerious ? 34.f : 0.f)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define  kWindow [UIApplication sharedApplication].keyWindow

#define kScreenScale (1.0 * SCREEN_HEIGHT / SCREEN_WIDTH)

#define kDesignHorizontalScale (SCREEN_WIDTH / 375.0)

#define kUserDefault [NSUserDefaults standardUserDefaults]

#define SYSTEM_VERSION_LESS_THAN(v) \
([[UIDevice currentDevice] systemVersion].floatValue < v)
#define STR_ENUM(N) [NSString stringWithFormat:@"%d", (int)N]


#define UIColorOfHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kNotificationCenter [NSNotificationCenter defaultCenter]

/**  Logger */
//#ifndef SHDDLogMacro_h
//#define SHDDLogMacro_h
//
//
//#if __has_include(<CocoaLumberjack/CocoaLumberjack.h>)
//#import <CocoaLumberjack/CocoaLumberjack.h>
//#else
//#import "DDLog.h"
//#endif
//
//#define CSLOG_TEST_FLAG2   (1001)
//#define CSLOG_TEST_LEVEL2   (SHLOG_TEST_FLAG2)
//#define CSLOG_TEST_DDLOG2(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, CSLOG_TEST_FLAG2,CSLOG_TEST_LEVEL2, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
//#endif 
static inline CGFloat AS(CGFloat size) {
    return (kDesignHorizontalScale * size);
}
static inline CGFloat AdaptSize(CGFloat size) {
    return (kDesignHorizontalScale * size);
}

static inline CGSize MakeAdaptCGSize(CGFloat width,CGFloat height) {
    return CGSizeMake(AdaptSize(width), AdaptSize(height));
}
/** 去子线程 */
static inline void dispatch_async_to_globalThread(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void dispatch_async_to_mainThread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline BOOL isIPhoneXSerious() {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
        return NO;
    }
    
    if (![UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        return NO;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return  CGSizeEqualToSize(screenSize, CGSizeMake(414, 896)) ||
    CGSizeEqualToSize(screenSize, CGSizeMake(375, 812)) ||
    CGSizeEqualToSize(screenSize, CGSizeMake(812, 375)) ||
    CGSizeEqualToSize(screenSize, CGSizeMake(896, 414));
}

