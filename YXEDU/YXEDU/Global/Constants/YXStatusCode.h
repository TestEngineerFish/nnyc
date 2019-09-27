//
//  YXStatusCode.h
//  YXEDU
//
//  Created by Jake To on 9/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const OK_CODE = 0;
static NSString *const OK_MSG = @"OK";
//
static NSInteger const FAILED_CODE = 1001;
static NSString *const FAILED_MSG = @"FAILED";
//
static NSInteger const PARAMS_CODE = 1002;
static NSString *const PARAMS_MSG = @"参数错误";

static NSInteger const SIGN_CODE = 1003;
static NSString *const SIGN_MSG = @"签名错误";

//系统类消息frequent
static NSInteger const SYS_FREQUENT_CODE = 10001;
static NSString *const SYS_FREQUENT_MSG = @"您请求的太频繁了";
//
static NSInteger const SYS_TOKEN_CODE = 10002; // token失效，超过7天
static NSString *const SYS_TOKEN_MSG = @"TOKEN不存在";

static NSInteger const SYS_TOKEN_FAILURE_CODE = 10003;///FAILURE 被踢出
static NSString *const SYS_TOKEN_FAILURE_MSG = @"TOKEN已失效";

static NSInteger const USER_PF_MOBILE_CAPTCHA_CODE = 11006;
static NSString *const  USER_PF_MOBILE_CAPTCHA_ERR_MSG = @"验证码输入错误";

static NSInteger const USER_PF_MOBILE_CAPTCHA_EMPTY_CODE = 11007;
static NSString *const USER_PF_MOBILE_CAPTCHA_EMPTY_ERR_MSG = @"验证码为空";

static NSInteger const USER_PF_MOBILE_LIMIT_CODE = 11008;
static NSString *const USER_PF_MOBILE_LIMIT_ERR_MSG = @"日验证码发送达到上限，请24小时后再试";

//用户类消息
static NSInteger const USER_MOBILE_BOUND_CODE = 11001;
static NSString *const USER_MOBILE_BOUND_MSG = @"用户已绑定过手机";
static NSInteger const USER_MOBILE_NO_BIND_CODE = 11002;
static NSString *const USER_MOBILE_NO_BIND_MSG = @"用户还未绑定过手机";
static NSInteger const USER_MOBILE_FORMAT_ERR_CODE = 11003;
static NSString *const USER_MOBILE_FORMAT_ERR_MSG = @"手机号不合法";
static NSInteger const USER_MOBILE_BIND_OTHER_ERR_CODE = 11004;

static NSInteger const USER_PF_BOUND_CODE = 11009;
static NSString *const USER_PF_BOUND_ERR_MSG = @"用户已绑定过此平台";

static NSInteger const USER_PF_VERIFY_ERR_CODE = 11010;
static NSString *const USER_PF_VERIFY_ERR_MSG = @"验证码错误";

/** 网络或其他原因导致 */
static NSInteger const kBADREQUEST_TYPE = -1009;
