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
static NSString *const universalLink   = @"https://nnyc-api.xstudyedu.com/";

#if DEBUG
// 测试
static NSString *const kBuglyAppId = @"c1901849b0";
#else
// 正式
static NSString *const kBuglyAppId = @"8d2147f017";
#endif
//static NSString *const kBuglyAppKey = @"2134e337-24e7-461c-841d-9b8a7cacba0c";


static NSString *const kGrowingIOID = @"ab8175453123d5b2";

// 友盟
static NSString *const kUmengAppKey    = @"5e7c11b7570df3f98d000120";
static NSString *const kUmengSecret    = @"ste3j7ruuerdaewmutcxrcj4kqybolgq";
static NSString *const kUmengAliasType = @"nnyc_alias_type";
#if DEBUG
static NSString *const kUmengChannel = @"Dev";
#else
// 正式
static NSString *const kUmengChannel = @"AppStore";
#endif

