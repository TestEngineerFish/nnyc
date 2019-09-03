//
//  YX_URL.h
//  YXEDU
//
//  Created by shiji on 2018/4/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCommHeader.h"

#define HTTPS 0

#define ENV 0 // 1:测试环境 2:开发环境 0:生产环境

#if HTTPS
#define SCHEME @"https://"
#else
#define SCHEME @"http://"
#endif


#if ENV == 1
#define YX_IP @"122.152.217.186"
#elif ENV == 2
#define YX_IP @"111.231.115.83:8081"
#else
#define YX_IP @"app.xstudyedu.com"
#endif




#define YX_DOMAIN STRCAT(YX_IP, @"/v1")


/*
 * api: user/reg 社交网络平台登录接口, 通过社交网络接口登录APP
 */
#define DOMAIN_LOGIN STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/reg"))

/*
 * api: user/logout 退出登录
 */
#define DOMAIN_LOGOUT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/logout"))

/*
 * 本接口用于上报数据, 登录后可调用, 需包含公共参数
 * api/statistics
 */
#define DOMAIN_STATISTICS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/statistics"))

/* 版本：v1.1
 * 获取词书配置
 */
#define DOMAIN_GETCONFIG3 STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/getconfig3"))

/*
 * 获取词书配置
 */
#define DOMAIN_GETCONFIG STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/getconfig"))

/*
 * 获取用户信息user/getinfo
 */
#define DOMAIN_GETUSERINFO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/getinfo"))

/*
 * 获取用户信息user/sendsms
 */
#define DOMAIN_SENDSMS STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/sendsms"))

/* 版本：v1.1
 * 图形验证码接口/api/captcha
 */
#define DOMAIN_CAPTCHA STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/captcha"))

/*
 * 获取用户信息user/getinfo
 */
#define DOMAIN_BINDMOBILE STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/bindmobile"))

/*
 * 设定要学习的图书 book/setlearning
 */
#define DOMAIN_SETLEARNING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/setlearning"))


/*
 * 获取正在学习的图书 book/getlearning
 */
#define DOMAIN_GETLEARNING STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/getlearning"))

/*
 * 添加一本词书到书架中 book/addbook/
 */
#define DOMAIN_ADDBOOK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/addbook"))

/*
 * 删除一本词书 book/delbook/ method: post
 */
#define DOMAIN_DELBOOK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/delbook"))

/*
 * 获取书籍列表 book/getbook/ method: post
 */
#define DOMAIN_GETBOOKLIST STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/book/getbooklist"))

/*
 * 获取单元题目 learning/getsubject ::method: get
 */
#define DOMAIN_BOOKUNIT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/bookunit"))

/*
 * 设定单词已选 learning/study ::method: post
 */
#define DOMAIN_STUDY STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/study"))

#define DOMAIN_AGREEMENT STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/agreement.html"))

/*
 * v1.1
 * 批量学习上报 /api/feedback ::method: post
 */
#define DOMAIN_FEEDBACK STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/feedback"))

/*
 * v1.1
 * 用户反馈 learning/batch ::method: post
 */
#define DOMAIN_BATCH STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/learning/batch"))

/*
 * v1.1
 * 检查版本更新 api/chkver ::method: Get
 */
#define DOMAIN_CHKVER STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/api/chkver"))

/*
 * v1.1
 * 绑定社交网络 user/bind ::method: POST
 */
#define DOMAIN_BINDSO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/bind"))

/*
 * v1.1
 * 解绑定社交网络 user/unbind ::method: POST
 */
#define DOMAIN_UNBINDSO STRCAT(SCHEME,STRCAT(YX_DOMAIN,@"/user/unbind"))
