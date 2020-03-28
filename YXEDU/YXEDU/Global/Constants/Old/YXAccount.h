//
//  YXAccount.h
//  YXEDU
//
//  Created by sunwu on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const qqId            = @"101475072";
static NSString *const wechatId        = @"wxa16b70cc1b2c98a0";
static NSString *const wechatAppSerect = @"23a8ccc80c48dea4337d6856d192a8d0";
static NSString *const jgId            = @"18071adc0320639477f";
static NSString *const baiduId         = @"1cjX8tynOTDsXpfpmvv3rtM7PQDRcVtO";
static NSString *const jpushId         = @"1839fa8b64ddd41f7859f81d"; // 测试
//static NSString *const jpushId = @"af610b352424e1fc7b70b0b2"; // 正式

//static NSString *const AppStoreLink = @"itms-apps://itunes.apple.com/cn/app/id1379948642?mt=8";
//static NSString *const kUmengAppKey = @"5bf7b6c0b465f5795e000425";

#if DEBUG
// 测试
static NSString *const kBuglyAppId = @"c1901849b0";
#else
// 正式
static NSString *const kBuglyAppId = @"8d2147f017";
#endif
//static NSString *const kBuglyAppKey = @"2134e337-24e7-461c-841d-9b8a7cacba0c";


static NSString *const kGrowingIOID = @"ab8175453123d5b2";


/// JPush
static NSString *const kJPushAppKey = @"af610b352424e1fc7b70b0b2";
#if DEBUG
static NSString *const kJPushChannel = @"Dev";
static NSInteger kJPushProduction = 0;
#else
// 正式
static NSString *const kJPushChannel = @"AppStore";
static NSInteger kJPushProduction = 1;
#endif

// 友盟
static NSString *const kUmengAppKey = @"5e7c11b7570df3f98d000120";
static NSString *const kUmengSecret = @"ste3j7ruuerdaewmutcxrcj4kqybolgq";

