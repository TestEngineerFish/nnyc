//
//  YRNetworkManager.h
//  YRNetwork
//
//  Created by pyyx on 2018/3/6.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRHttpTask.h"
#import "YRHttpDownloadTask.h"
#import "YRNetworkConfiguration.h"


// #################################################################
// =================================================================
// =================================================================
/**
 *  文件
 */
@interface YRFormFile : NSObject

@property (nonatomic, copy) NSString    *name;//设置远端地址
@property (nonatomic, copy) NSString    *filename;//设置文件名
@property (nonatomic, copy) NSString    *mineType;//类型
@property (nonatomic, copy) NSURL       *filePathURL;//文件地址
@property (nonatomic, copy) NSData      *data;//data数据

@end


// #################################################################
// =================================================================
// =================================================================
/**
 * 网络访问管理类
 */
@interface YRNetworkManager : NSObject
@property (nonatomic, weak) id<YRNetworkConfiguration> configuration;

/** 单例对象 */
+ (instancetype)sharedManager;

/**
 * 在请求数据时，设置HTTP头参数，如果实现了 configuration 中的httpHeaderFields
 */
- (void)setHeaderFields:(NSDictionary *) fields;


#pragma mark - POST
/**
 * HTTP GET请求，数据不做缓存，不读取缓存
 * @param       url             接口地址
 * @param       params          参数
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
         completion:(YRHttpCompletion) completion;

/**
 * HTTP GET请求，支持进行缓存数据，支持读取缓存数据
 * @param       url             接口地址
 * @param       params          参数
 * @param       cachePolicy     缓存策略
 * @param       useCache        是否使用缓存
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
              cache:(YRHttpResponseCachePolicy) cachePolicy
           useCache:(BOOL) useCache
         completion:(YRHttpCompletion) completion;

/**
 * HTTP GET请求，支持进行缓存数据，支持读取缓存数据
 * @param       url             接口地址
 * @param       params          参数
 * @param       headers         头字段
 * @param       cachePolicy     缓存策略
 * @param       useCache        是否使用缓存
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
            headers:(NSDictionary *) headers
              cache:(YRHttpResponseCachePolicy) cachePolicy
           useCache:(BOOL) useCache
         completion:(YRHttpCompletion) completion;


#pragma mark - POST

/**
 * HTTP POST请求，数据不做缓存，不读取缓存
 * @param       url             接口地址
 * @param       params          参数
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
          completion:(YRHttpCompletion) completion;


/**
 * HTTP POST请求，支持进行缓存数据，支持读取缓存数据
 * @param       url             接口地址
 * @param       params          参数
 * @param       cachePolicy     缓存策略
 * @param       useCache        是否使用缓存
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
               cache:(YRHttpResponseCachePolicy) cachePolicy
            useCache:(BOOL) useCache
          completion:(YRHttpCompletion) completion;


/**
 * HTTP POST请求，支持进行缓存数据，支持读取缓存数据
 * @param       url             接口地址
 * @param       params          参数
 * @param       headers         头字段
 * @param       cachePolicy     缓存策略
 * @param       useCache        是否使用缓存
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
             headers:(NSDictionary *) headers
               cache:(YRHttpResponseCachePolicy) cachePolicy
            useCache:(BOOL) useCache
          completion:(YRHttpCompletion) completion;

#pragma mark - Upload

/**
 * HTTP 上传
 * @param       url             接口地址
 * @param       params          参数  [文件对应的数据要放到该字典中，file=data；文件名称使用fileName传递，例如fileName=images，不传默认名称为file<fileName=file>]
 * @param       filePath        文件路径
 * @param       headers         头字段
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)upload:(NSString *) url
            parameters:(NSDictionary *) params
           appendFiles:(NSString *) filePath
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress) progress
            completion:(YRHttpCompletion) completion DEPRECATED_ATTRIBUTE;

/**
 * HTTP 上传
 * @param       url             接口地址
 * @param       params          参数  [文件对应的数据要放到该字典中，file=data；文件名称使用fileName传递，例如fileName=images，不传默认名称为file<fileName=file>]
 * @param       filePath        文件路径
 * @param       headers         头字段
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)upload:(NSString *) url
            parameters:(NSDictionary *) params
              filePath:(NSString *) filePath
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress) progress
            completion:(YRHttpCompletion) completion;

/**
 * HTTP 上传
 * @param       url             接口地址
 * @param       params          参数
 * @param       formFiles       文件
 * @param       headers         头字段
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)upload:(NSString *)url
            parameters:(NSDictionary *)params
       appendFormFiles:(NSArray<YRFormFile *> *)formFiles
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress)progress
            completion:(YRHttpCompletion) completion;


#pragma mark - Download
/**
 * HTTP 下载请求
 * @param       url             接口地址
 * @param       params          参数
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)download:(NSString *) url
          parameters:(NSDictionary *) params
          downloadProgress:(YRHttpDownloadProgress)progress
          completion:(YRHttpCompletion) completion;

/**
 * HTTP 下载请求
 * @param       url             接口地址
 * @param       params          参数
 * @param       headers         头字段
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpTask *)download:(NSString *) url
              parameters:(NSDictionary *) params
                 headers:(NSDictionary *) headers
        downloadProgress:(YRHttpDownloadProgress)progress
              completion:(YRHttpCompletion) completion;


/**
 * HTTP 下载请求
 * @param       url             接口地址
 * @param       params          参数
 * @param       headers         头字段
 * @param       tmpFileDir      临时文件
 * @param       dstFilePath     目标文件
 * @param       progress        进度
 * @param       completion      响应结果，包括成功和失败
 */
- (YRHttpDownloadTask *)download:(NSString *) url
                      parameters:(NSDictionary *) params
                         headers:(NSDictionary *) headers
                     tmpFilePath:(NSString *)tmpFileDir
                     dstFilePath:(NSString *)dstFilePath
                downloadProgress:(YRHttpDownloadProgress)progress
                      completion:(YRHttpCompletion) completion;

/**
 * 取消所有的网络请求
 */
- (void)cancelAllTask;

@end
