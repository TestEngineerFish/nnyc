
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
#import <CocoaLumberjack/CocoaLumberjack.h>

/**
flag 系统默认枚举值的位移范围是 0 到 4，不要和宿主 app 的自定义枚举重复
context 系统默认是0，不要和宿主 app 的自定义 context 重复
*/
#define LOG_FLAG_MAIL (1 << 15)
#define LOG_CONTEXT_MAIL 15

// 使用 HLULog 代替 DDLog，防止项目中误用 DDLog
#undef DDLogError
#undef DDLogWarn
#undef DDLogInfo
#undef DDLogDebug
#undef DDLogVerbose

//#define CSLOG_TEST_DDLOG2(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, CSLOG_TEST_FLAG2,CSLOG_TEST_LEVEL2, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
// 自定义 4 个 Log 宏
//#define YXLogError(frmt, ...)   LOG_MAYBE(YES, ddLogLevel, DDLogFlagError,   LOG_CONTEXT_MAIL, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
//#define YXLogWarn(frmt, ...)    LOG_MAYBE(YES, ddLogLevel, DDLogFlagWarning, LOG_CONTEXT_MAIL, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define YXLogInfo(frmt, ...)    LOG_MAYBE(YES, ddLogLevel, DDLogFlagInfo, LOG_CONTEXT_MAIL, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
//#define YXLogDebug(frmt, ...)   LOG_MAYBE(YES, ddLogLevel, DDLogFlagDebug,   LOG_CONTEXT_MAIL, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
//#define YXLogVerbose(frmt, ...) LOG_MAYBE(YES, ddLogLevel, DDLogFlagVerbose, LOG_CONTEXT_MAIL, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

// 可能会报类型错误，所以用(DDLogLevel)强转一下
#ifdef DEBUG
static const DDLogLevel ddLogLevel = (DDLogLevel)(DDLogLevelVerbose | LOG_FLAG_MAIL);
#else
static const DDLogLevel ddLogLevel = (DDLogLevel)(DDLogLevelInfo | LOG_FLAG_MAIL);
#endif

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

