//
//  YRMacro.h
//  pyyx
//
//  Created by sunwu on 2017/11/9.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#ifndef YRMacro_h
#define YRMacro_h



//////////////////////////
/// build enviroments
//////////////////////////

//#define BUILD_ENVIROMENT_TARGET_PYYX              1
//#define BUILD_ENVIROMENT_TARGET_PYYX_IN_HOUSE     2
//#define BUILD_ENVIROMENT_DEVELOPMENT              4
//#define BUILD_ENVIROMENT_ADHOC                    8
//#define BUILD_ENVIROMENT_DISTRIBUTE               16

#define BUILD_ENVIROMENT_PYYX_DEVELOPMENT         1
#define BUILD_ENVIROMENT_PYYX_ADHOC               2
#define BUILD_ENVIROMENT_PYYX_APP_STORE           3
#define BUILD_ENVIROMENT_IN_HOUSE_DEVELOPMENT     4
#define BUILD_ENVIROMENT_IN_HOUSE_ADHOC           5
#define BUILD_ENVIROMENT_IN_HOUSE_DISTRIBUTE      6

//#ifndef BUILD_ENVIROMENT
//#define BUILD_ENVIROMENT    BUILD_ENVIROMENT_PYYX_DEVELOPMENT
//#endif

#define BUILD_ENVIROMENT_IS_TEST               ((BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_DEVELOPMENT) || BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_DEVELOPMENT || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_ADHOC))
#define BUILD_ENVIROMENT_IS_PYYX               ((BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_DEVELOPMENT) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_ADHOC) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_APP_STORE))
#define BUILD_ENVIROMENT_IS_IN_HOUSE           ((BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_DEVELOPMENT) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_ADHOC) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_DISTRIBUTE))
#define BUILD_ENVIROMENT_IS_PRODUCTION         ((BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_ADHOC) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_PYYX_APP_STORE) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_ADHOC) || (BUILD_ENVIROMENT == BUILD_ENVIROMENT_IN_HOUSE_DISTRIBUTE))


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define SuppressProtocolMethodImplementationWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wobjc-protocol-method-implementation\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//////////////////////////
/// assert
//////////////////////////
#define NSParameterAssertReturn(condition, returnValue)             {if (!(condition)) { DDLogError(@"%s Invalid parameter not satisfying: %@", __func__, @#condition); return returnValue;}}
#define NSParameterAssertReturnNil(condition)                       NSParameterAssertReturn(condition, nil)
#define NSParameterAssertReturnVoid(condition)                      {if (!(condition)) { DDLogError(@"%s Invalid parameter not satisfying: %@", __func__, @#condition); return;}}

//////////////////////////
/// common caculate
//////////////////////////
#define select(condition, vTrue, vFalse)                         ((condition)?(vTrue):(vFalse))
#define between(value, minValue, maxValue)                       (value > minValue && value < maxValue)
#define betweenWith(value, minValue, maxValue)                   (value >= minValue && value <= maxValue)



/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


#ifdef DEBUG
#   define GDDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define GDDLog(...)
#endif
/* ****************************************************************************************************************** */





#endif /* YRMacro_h */
