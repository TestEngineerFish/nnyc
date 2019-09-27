//
//  YRNetworkConfiguration.h
//  YRHttpManager
//
//  Created by sunwu on 2018/2/27.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YRHttpResponse;

/**
 * 缓存策略
 */
typedef NS_ENUM(NSInteger, YRHttpResponseCachePolicy) {
    YRHttpResponseCachePolicyNone,        // 不缓存，默认
    YRHttpResponseCachePolicyNormal      // 普通缓存，一直保持，不删除
    //    YRHttpResponseCachePolicyDay,         // 保存一天，过期删除
    //    YRHttpResponseCachePolicyWeek,        // 保存一周，过期删除
    //    YRHttpResponseCachePolicyMonth,       // 保存一个月，过期删除
    //    YRHttpResponseCachePolicyQuarter,     // 保存一个季度，过期删除
    //    YRHttpResponseCachePolicyYear,        // 保存一年，过期删除
};


/**
 * 请求类型
 */
typedef NS_ENUM(NSInteger, YRHttpRequestType) {
    YRHttpRequestTypeGet,
    YRHttpRequestTypePost,
    YRHttpRequestTypePut,
    YRHttpRequestTypeDelete,
    YRHttpRequestTypeUpload,
    YRHttpRequestTypeDownload,
    
    YRHttpRequestTypeCache  //没有网络请求
};


/**
 * 请求响应结果，成功和失败
 */
typedef void (^YRHttpCompletion) (YRHttpResponse *response);

/**
 * 上传进度
 */
typedef void (^YRHttpUploadProgress)(NSProgress *uploadProgress);

/**
 * 上传进度
 */
typedef void (^YRHttpDownloadProgress)(NSProgress *downloadProgress);



// =================================================================
// =================================================================
// =================================================================
/**
 * 配置信息协议，业务方必须实现该协议
 */
@protocol YRNetworkConfiguration <NSObject>

@optional
/**
 * 设置基础URL
 */
- (NSURL *)baseUrl;

/**
 * 设置基础http header头，在 YRNetworkManager 初始化时设置的固定值
 */
- (NSDictionary *)httpHeaderFields;

/**
 * 设置http header头，在请求接口数据时设置，例如，接口加密等动态计算的参数
 */
- (NSDictionary *)httpHeaderFields:(NSDictionary *) params;

/**
 * 设置http header头，在请求接口数据时设置，例如，接口加密等动态计算的参数
 */
- (NSDictionary *)httpHeaderFields:(NSDictionary *) params url:(NSString *) url;

/**
 * 处理请求数据，可进行解析处理，返回解析的后的数据
 */
- (id)response:(YRHttpResponse *) response completion:(YRHttpCompletion) completion;

/**
 * 网络异常
 */
- (void)networkError:(YRHttpResponse *) response;

/**
 * 用户缓存标识符，如果业务端需要缓存不同用户的数据，需要设置一个标识符，每个用户必须不一样
 */
- (NSString *)userIdentifier;


@end

