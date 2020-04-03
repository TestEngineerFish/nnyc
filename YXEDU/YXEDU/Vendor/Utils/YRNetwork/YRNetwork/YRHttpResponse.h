//
//  YRHttpResponse.h
//  YRHttpManager
//
//  Created by sunwu on 2018/2/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YRError.h"
#import "YRNetworkConfiguration.h"

@interface YRHttpResponse : NSObject

/** 返回数据 */
@property (nonatomic, strong, readonly) id _Nonnull responseObject;

/** 业务状态码，非http状态码 */
@property (nonatomic, assign, readonly) NSInteger statusCode;

/** 业务状态详细描述信息*/
@property (nonatomic, copy, nullable, readonly) NSString* message;

/** 错误详情 */
@property (nonatomic, strong, readonly) YRError * _Nullable error;

/** 是否来自缓存 */
@property (nonatomic, assign, readonly) BOOL isCache;

///** 当前数据的缓存类型 */
//@property (nonatomic, assign, readonly) YRHttpResponseCachePolicy cachePolicy;
//
/** 请求类型 */
@property (nonatomic, assign, readonly) YRHttpRequestType requestType;
//
///** 响应对象 */
@property (nonatomic, strong, readonly) NSURLSessionTask * _Nonnull sessionTask;

/**
 * 构建Response【由YRNetworkManager 响应时进行构建】，业务使用方法不需要创建该对象
 */
- (instancetype _Nonnull )initWithResponseObject:(id _Nonnull ) responseObject
                            statusCode:(NSInteger) statusCode
                               message:(nullable NSString*) message
                                 error:(YRError *_Nullable) error
                               isCache:(BOOL) isCache
                           requestType:(YRHttpRequestType) requestType
                                  task:(NSURLSessionTask *_Nonnull) sessionTask;
@end




