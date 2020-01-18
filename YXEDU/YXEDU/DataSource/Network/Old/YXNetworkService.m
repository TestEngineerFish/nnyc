//
//  YXNetworkService.m
//  YXEDU
//
//  Created by shiji on 2018/4/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXNetworkService.h"
#import "YXConfigure.h"
#import "NSData+YR.h"
#import "NSDictionary+YR.h"
#import "YXConfigure.h"
#import "YXMediator.h"
#import "YXAPI.h"
#import "YXUtils.h"
// #import "AppDelegate.h"

#define kSault @"NvYP1OeQZqzJdxt8"


@interface YXNetworkService () <YRNetworkConfiguration>

@end

@implementation YXNetworkService

+ (instancetype)shared {
    return [super sharedManager];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configuration = self;
    }
    return self;
}

- (NSURL *)baseUrl {
    return [NSURL URLWithString:@""];
}

#pragma mark - <YRNetworkConfiguration>
- (NSDictionary *)httpHeaderFields:(NSDictionary *)params url:(NSString *)url {
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    NSString *NNYC_TOKEN = [YXConfigure shared].token;
    if (NNYC_TOKEN) {
        [headerDic setObject:NNYC_TOKEN forKey:@"NNYC-TOKEN"];
    }
    
    [headerDic setObject:kPlatformValue forKey:@"NNYC-PLATFORM"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
//    if ([url containsString:@"getconfig"]) {   //v1.3.2 修复config不包含新书信息
//        version = @"140";
//    }
    
    [headerDic setObject:version forKey:@"NNYC-VERSION"];
    
    NSMutableArray *keyArr = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [keyArr addObject:key];
    }];
    NSArray *sortedKeys = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 caseInsensitiveCompare:obj2];
        if (result == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if (result == NSOrderedDescending){
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        NSString *value = params[key];
        [resultArr addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    NSMutableString *signStr = [NSMutableString string];
    if (resultArr.count) {
        [signStr appendFormat:@"%@", [resultArr componentsJoinedByString:@"&"]];
    }
    if ([YXConfigure shared].time.length > 0) {
        [signStr appendFormat:@"#%@#", [YXConfigure shared].time];
    } else {
        [signStr appendString:@"#0#"];
    }
    [signStr appendFormat:@"%@@", kSault];
    if ([YXConfigure shared].token.length > 0) {
        [signStr appendFormat:@"%@", [YXConfigure shared].token];
    }
    [headerDic setObject:[[signStr dataUsingEncoding:NSUTF8StringEncoding] md5String] forKey:@"NNYC-SIGN"];
    NSString *NNYC_REQUESTTIME = [YXConfigure shared].time;
    if (NNYC_REQUESTTIME) {
        [headerDic setObject:NNYC_REQUESTTIME forKey:@"NNYC-REQUESTTIME"];
    }
    return headerDic;
}

- (void)networkError:(YRHttpResponse *)response {
//    response.error.desc = @"网络错误";
    
    NSDictionary *oriErrorUserInfo = response.error.originalError.userInfo;
    NSString *failingkey = [oriErrorUserInfo objectForKey:@"NSErrorFailingURLKey"];
    response.error.type = kBADREQUEST_TYPE;
    if ([failingkey.pathExtension isEqualToString:@"mp3"]) { // not found resource,音频资源不显示吐司报错
        return;
    }
    
    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:response.error.desc];
}

- (id)response:(YRHttpResponse *)response completion:(YRHttpCompletion)completion {
    NSDictionary *responseObject = response.responseObject;
    NSString* _responseMessage = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        _responseMessage = responseObject[@"message"];
    }
    
    // 如果是下载数据，就不用进行拆包解析
    if (response.requestType == YRHttpRequestTypeDownload) {
        YRHttpResponse *httpResponse = [[YRHttpResponse alloc] initWithResponseObject:responseObject
                                                                           statusCode:0
                                                                              message:_responseMessage
                                                                                error:nil
                                                                              isCache:response.isCache
                                                                          requestType:response.requestType
                                                                                 task:response.sessionTask];
        // 把解析后的数据抛给上层业务方
        if (completion) completion(httpResponse);
        return nil;// 下载数据不用进行返回
    }
    
    if ([responseObject[@"code"] intValue] == 0) {
        [YXConfigure shared].time = [NSString stringWithFormat:@"%d", [responseObject[@"time"]intValue]];
        id data = responseObject[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = data;
            NSArray *task = [dic objectForKey:@"task"];
            [YXConfigure shared].confModel.completedTaskAry = task;
        }
        YRHttpResponse *httpResponse = [[YRHttpResponse alloc] initWithResponseObject:responseObject[@"data"]
                                                                           statusCode:0
                                                                              message:_responseMessage
                                                                                error:nil
                                                                              isCache:response.isCache
                                                                          requestType:response.requestType
                                                                                 task:response.sessionTask];
//        httpResponse = [YRHttpResponse alloc]initWithResponseObject:responseObject[@"data"] statusCode:0 message:@"" error:nil isCache:<#(BOOL)#> requestType:<#(YRHttpRequestType)#> task:<#(NSURLSessionTask *)#>
        // 把解析后的数据抛给上层业务方
        if (completion) completion(httpResponse);
        return httpResponse.responseObject;
    } else {
        YRError *error = [YRError errorWithCode:[responseObject[@"code"] integerValue] desc:[responseObject[@"msg"] description]];
        [YXConfigure shared].time = [NSString stringWithFormat:@"%d", [responseObject[@"time"]intValue]];
        if (error.code == FAILED_CODE ||
            error.code == PARAMS_CODE ||
            error.code == SYS_FREQUENT_CODE ||
            error.code == USER_MOBILE_BOUND_CODE ||
            error.code == USER_MOBILE_NO_BIND_CODE ||
            error.code == USER_MOBILE_FORMAT_ERR_CODE ||
            error.code == USER_MOBILE_BIND_OTHER_ERR_CODE ||
            error.code == USER_PF_MOBILE_CAPTCHA_CODE ||
            error.code == USER_PF_BOUND_CODE ||
            error.code == USER_PF_MOBILE_LIMIT_CODE ||
            error.code == USER_PF_VERIFY_ERR_CODE) { // 验证码错误
            [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:error.desc];
        } else if (error.code == SYS_TOKEN_CODE) { // TOKEN失效，弹出登录页面
//            [[YXMediator shared] afterLogout];
//            [[YXMediator shared] tokenExpired];
            [[YXUserModel default] updateToken];
            
        } else if (error.code == SYS_TOKEN_FAILURE_CODE) { // 被踢出
//            [[YXMediator shared] clearData];
            [[YXMediator shared] userKickedOut];
        } else  if (error.code == 6666) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kServiceStopNotification" object:nil];
        }
        
        YRHttpResponse *httpResponse = [[YRHttpResponse alloc] initWithResponseObject:responseObject
                                                                           statusCode:[responseObject[@"code"] intValue]
                                                                              message:@""
                                                                                error:error
                                                                              isCache:response.isCache
                                                                          requestType:response.requestType
                                                                                 task:response.sessionTask];
        // 把解析后的错误信息数据抛给上层业务方
        if (completion) completion(httpResponse);
        return nil;
    }
    return nil;
}

@end
