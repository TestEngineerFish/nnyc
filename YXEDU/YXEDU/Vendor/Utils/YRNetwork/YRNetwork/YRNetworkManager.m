//
//  YRNetworkManager.m
//  YRNetwork
//
//  Created by pyyx on 2018/3/6.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRNetworkManager.h"

#import "YRHttpResponse.h"
#import "YRHttpDownloadTask.h"
#import "YRNetworkManager+Cache.h"
#import <AFNetworking/AFNetworking.h>
//#import <AFNetworking/UIKit+AFNetworking.h>


@implementation YRFormFile
@end


@interface YRNetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray<YRHttpTask *> *httpTasks;

@end


@implementation YRNetworkManager

+ (instancetype)sharedManager {
    static YRNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _httpTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Set Header
- (void)setHeaderFields:(NSDictionary *) fields {
    [self _setHeader:fields];
}

#pragma mark - GET
- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
         completion:(YRHttpCompletion) completion {
    return [self GET:url parameters:params cache:YRHttpResponseCachePolicyNone useCache:NO completion:completion];
}

- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
              cache:(YRHttpResponseCachePolicy) cachePolicy
           useCache:(BOOL) useCache
         completion:(YRHttpCompletion) completion {
    return [self GET:url parameters:params headers:nil cache:YRHttpResponseCachePolicyNone useCache:useCache completion:completion];
}

- (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
            headers:(NSDictionary *) headers
              cache:(YRHttpResponseCachePolicy) cachePolicy
           useCache:(BOOL) useCache
         completion:(YRHttpCompletion) completion {
    
    // 读取缓存
    [self readCacheData:url params:params cache:useCache completion:completion];
    
    // 设置两种方式的heeader头参数
    NSDictionary *feilds = [self _setAllHeader:headers params:params url:url];
    
    NSURLSessionDataTask *task = [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 删除已完成的task
        [self _removeTask:task];
                
        [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypeGet task:task completion:completion];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除已完成的task
        [self _removeTask:task];
        
        YRHttpResponse *response = [self _failureResponse:task error:error requestType:YRHttpRequestTypeGet ];
        completion ? completion(response) : nil;
    }];
    
    YRHttpTask *yrTask = [[YRHttpTask alloc] initWithTask:task withUrl:url withParams:params withHeader:feilds];
    [_httpTasks addObject:yrTask];
    return yrTask;
    
}

#pragma mark - POST
- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
          completion:(YRHttpCompletion) completion {
    return [self POST:url parameters:params cache:YRHttpResponseCachePolicyNone useCache:NO completion:completion];
}

- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
               cache:(YRHttpResponseCachePolicy) cachePolicy
            useCache:(BOOL) useCache
          completion:(YRHttpCompletion) completion {
    return [self POST:url parameters:params headers:nil cache:YRHttpResponseCachePolicyNone useCache:useCache completion:completion];
}

- (YRHttpTask *)POST:(NSString *) url
          parameters:(NSDictionary *) params
             headers:(NSDictionary *) headers
               cache:(YRHttpResponseCachePolicy) cachePolicy
            useCache:(BOOL) useCache
          completion:(YRHttpCompletion) completion {
    
    // 读取缓存
    [self readCacheData:url params:params cache:useCache completion:completion];
    
    // 设置两种方式的heeader头参数
    NSDictionary *feilds = [self _setAllHeader:headers params:params url:url];
    NSLog(@"params--%@",params);
    NSURLSessionDataTask *task = [self.sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 删除已完成的task
        [self _removeTask:task];
        
        NSLog(@"POST = request url:%@",task.originalRequest.URL.absoluteString);
        [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypePost task:task completion:completion];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除已完成的task
        [self _removeTask:task];
        
        YRHttpResponse *response = [self _failureResponse:task error:error requestType:YRHttpRequestTypePost ];
        completion ? completion(response) : nil;
        
    }];
    
    YRHttpTask *yrTask = [[YRHttpTask alloc] initWithTask:task withUrl:url withParams:params withHeader:feilds];
    [_httpTasks addObject:yrTask];
    return yrTask;
}

#pragma mark - Upload
- (YRHttpTask *)upload:(NSString *) url
            parameters:(NSDictionary *) params
           appendFiles:(NSString *) filePath
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress) progress
            completion:(YRHttpCompletion) completion {
    
    return [self upload:url parameters:params filePath:filePath headers:headers uploadProgress:progress completion:completion];
}


- (YRHttpTask *)upload:(NSString *) url
            parameters:(NSDictionary *) params
              filePath:(NSString *) filePath
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress) progress
            completion:(YRHttpCompletion) completion {
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSData *fileData = [newParams objectForKey:@"file"];
    [newParams removeObjectForKey:@"file"];
    
    YRFormFile *formFile = [[YRFormFile alloc] init];
    
    if (filePath) {
        formFile.filePathURL =  [NSURL fileURLWithPath:filePath];
    } else {
        formFile.filename = @"photo.jpg";
        formFile.mineType = @"image/jpeg";
    }
    
    if ([newParams objectForKey:@"fileName"]) {
        formFile.name = newParams[@"fileName"];
    } else {
        formFile.name = @"file";
    }
    formFile.data = fileData;
    
    return [self upload:url parameters:newParams appendFormFiles:@[formFile] headers:headers uploadProgress:progress completion:completion];
}

- (YRHttpTask *)upload:(NSString *)url
            parameters:(NSDictionary *)params
       appendFormFiles:(NSArray<YRFormFile *> *)formFiles
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress)progress
            completion:(YRHttpCompletion) completion{
    
    // 设置两种方式的heeader头参数
    NSDictionary *feilds = [self _setAllHeader:headers params:params url:url];
    
    NSURLSessionDataTask *task = [self.sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (YRFormFile *formFile in formFiles) {
            if (formFile.filePathURL) {
                [formData appendPartWithFileURL:formFile.filePathURL name:formFile.name error:nil];            
            } else if (formFile.data) {
                [formData appendPartWithFileData:formFile.data
                                            name:formFile.name
                                        fileName:[self _emptyString:formFile.filename]
                                        mimeType:[self _emptyString:formFile.mineType]];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 删除已完成的task
        [self _removeTask:task];
        
        [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypeUpload task:task completion:completion];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 删除已完成的task
        [self _removeTask:task];
        
        YRHttpResponse *response = [self _failureResponse:task error:error requestType:YRHttpRequestTypeUpload];
        completion ? completion(response) : nil;
    }];
    
    YRHttpTask *yrTask = [[YRHttpTask alloc] initWithTask:task withUrl:url withParams:params withHeader:feilds];
    [_httpTasks addObject:yrTask];
    return yrTask;
}



#pragma mark - Download

- (YRHttpTask *)download:(NSString *) url
              parameters:(NSDictionary *) params
        downloadProgress:(YRHttpDownloadProgress)progress
              completion:(YRHttpCompletion) completion {
    return [self download:url parameters:params headers:nil downloadProgress:progress completion:completion];
}

- (YRHttpTask *)download:(NSString *) url
              parameters:(NSDictionary *) params
                 headers:(NSDictionary *) headers
        downloadProgress:(YRHttpDownloadProgress)progress
              completion:(YRHttpCompletion) completion {
    // 设置两种方式的heeader头参数
    NSDictionary *feilds = [self _setAllHeader:headers params:params url:url];
    
    NSString *nsUrl = url;
    if ([self _baseUrl]) {
        nsUrl = [[[self _baseUrl] absoluteString] stringByAppendingString:url];
    }
    
    NSMutableURLRequest *request =[self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:nsUrl parameters:params error:nil];
    NSURLSessionDownloadTask *task = nil;
    task = [self.sessionManager downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //保存的文件路径
        NSString *fileName = [NSString stringWithFormat:@"%f%@", [[NSDate date] timeIntervalSince1970], response.suggestedFilename];
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            NSData *responseObject = [NSData dataWithContentsOfURL:filePath];
            [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypeDownload task:nil completion:completion];
            
            // 删除已经下载的数据
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtURL:filePath error:nil];
            //            NSLog(@"下载数据完成，删除操作 %@", res ? @"成功" : @"失败");
        } else {
            YRHttpResponse *response = [self _failureResponse:nil error:error requestType:YRHttpRequestTypeDownload ];
            completion ? completion(response) : nil;
        }
    }];
    
    [task resume];
    
    YRHttpTask *yrTask = [[YRHttpTask alloc] initWithTask:task withUrl:url withParams:params withHeader:feilds];
    [_httpTasks addObject:yrTask];
    return yrTask;
}


- (YRHttpDownloadTask *)download:(NSString *) url
              parameters:(NSDictionary *) params
                 headers:(NSDictionary *) headers
             tmpFilePath:(NSString *)tmpFileDir
             dstFilePath:(NSString *)dstFilePath
        downloadProgress:(YRHttpDownloadProgress)progress
              completion:(YRHttpCompletion) completion {
    
    // 设置两种方式的heeader头参数
    NSDictionary *feilds = [self _setAllHeader:headers params:params url:url];
    
    NSString *nsUrl = url;
    if ([self _baseUrl]) {
        nsUrl = [[[self _baseUrl] absoluteString] stringByAppendingString:url];
    }
    
    NSMutableURLRequest *request =[self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:nsUrl parameters:params error:nil];
    NSURLSessionDownloadTask *task = nil;
    
    NSData *downloadData = [NSData dataWithContentsOfFile:[tmpFileDir stringByAppendingPathComponent:@"file.db"]];
    if (downloadData) {
        [self moveToTempFile:tmpFileDir];
        task = [self.sessionManager downloadTaskWithResumeData:downloadData progress:^(NSProgress * _Nonnull downloadProgress) {
            progress(downloadProgress);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //保存的文件路径
            return [NSURL fileURLWithPath:dstFilePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                NSData *responseObject = [NSData dataWithContentsOfURL:filePath];
                [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypeDownload task:nil completion:completion];
                
                // 删除已经下载的数据
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtURL:filePath error:nil];
                [fileManager removeItemAtPath:[tmpFileDir stringByAppendingPathComponent:@"file.db"] error:nil];
            } else {
                YRHttpResponse *response = [self _failureResponse:nil error:error requestType:YRHttpRequestTypeDownload ];
                completion ? completion(response) : nil;
            }
        }];
    } else {
        task = [self.sessionManager downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //保存的文件路径
            return [NSURL fileURLWithPath:dstFilePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (!error) {
                NSData *responseObject = [NSData dataWithContentsOfURL:filePath];
                [self _successResponse:responseObject url:url params:params requestType:YRHttpRequestTypeDownload task:nil completion:completion];
                
                // 删除已经下载的数据
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtURL:filePath error:nil];
                [fileManager removeItemAtPath:[tmpFileDir stringByAppendingPathComponent:@"file.db"] error:nil];
                //            NSLog(@"下载数据完成，删除操作 %@", res ? @"成功" : @"失败");
            } else {
                YRHttpResponse *response = [self _failureResponse:nil error:error requestType:YRHttpRequestTypeDownload ];
                completion ? completion(response) : nil;
            }
        }];
    }
    //执行Task
    [task resume];
    
    YRHttpDownloadTask *yrTask = [[YRHttpDownloadTask alloc] initWithTask:task withUrl:url withParams:params withHeader:feilds];
    yrTask.tmpFileDir = tmpFileDir;
    [_httpTasks addObject:yrTask];
    return yrTask;
}

- (void)moveToTempFile:(NSString *)tmpFileDir {
    NSArray *paths = [[NSFileManager defaultManager]subpathsAtPath:tmpFileDir];
    for (NSString *fileName in paths) {
        if ([fileName rangeOfString:@"CFNetworkDownload"].length>0) {
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            //反向移动
            [[NSFileManager defaultManager]copyItemAtPath:[tmpFileDir stringByAppendingPathComponent:fileName] toPath:path error:nil];
        }
    }
}



#pragma mark - Cancel
- (void)cancelAllTask {
    [_httpTasks enumerateObjectsUsingBlock:^(YRHttpTask *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [_httpTasks removeAllObjects];
}

#pragma mark - set & get
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        
        if ([self _baseUrl]) {
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self _baseUrl]];
        } else {
            _sessionManager = [[AFHTTPSessionManager alloc] init];
        }
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 60;
        _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        _sessionManager.responseSerializer = response;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        // 初始化时设置头信息
        [self _setHttpHeaderFields];
    }
    return _sessionManager;
}

#pragma mark - private method

- (NSURL *)_baseUrl{
    if (self.configuration && [self.configuration respondsToSelector:@selector(baseUrl)]) {
        NSURL *url = [self.configuration baseUrl];
        if ([url.absoluteString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
            return nil;
        }
        return url;
    }
    return nil;
}

- (void)_setHttpHeaderFields {
    if (self.configuration && [self.configuration respondsToSelector:@selector(httpHeaderFields)]) {
        NSDictionary *dic =  [self.configuration httpHeaderFields];
        [self _setHeader:dic];
    }
}

- (NSDictionary *)_setHttpHeaderFields:(NSDictionary *)params {
    if (self.configuration && [self.configuration respondsToSelector:@selector(httpHeaderFields:)]) {
        NSDictionary *dic = [self.configuration httpHeaderFields:params];
        [self _setHeader:dic];
        return dic;
    }
    return nil;
}

- (NSDictionary *)_setHttpHeaderFields:(NSDictionary *)params url:(NSString *) url {
    if (self.configuration && [self.configuration respondsToSelector:@selector(httpHeaderFields: url:)]) {
        NSDictionary *dic = [self.configuration httpHeaderFields:params url:url];
        [self _setHeader:dic];
        return dic;
    }
    return nil;
}


- (NSDictionary *)_setAllHeader:(NSDictionary *)headers params:(NSDictionary *)params url:(NSString *) url {
    // 设置两种方式的heeader头参数
    [self _setHeader:headers];
    NSDictionary *feilds = [self _setHttpHeaderFields:params];
    return feilds ? feilds : [self _setHttpHeaderFields:params url:url];
}

/**
 * 设置头字段
 */
- (void)_setHeader:(NSDictionary *)fields {
    if (!fields || !fields.count) return;
    
    NSArray<NSString *> *allKeys = [fields allKeys];
    [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = fields[obj];
        [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:obj];
    }];
    
}

/**
 * 数据请求成功处理
 */
- (void )_successResponse:(id) responseObject
                      url:(NSString *) url
                   params:(NSDictionary *) params
              requestType:(YRHttpRequestType) requestType
                     task:(NSURLSessionDataTask *) task
               completion:(YRHttpCompletion) completion {

    YRHttpResponse *httpResponse;
    NSString* _responseMessage = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        _responseMessage = responseObject[@"message"];
    }
    // 业务方有实现自己的解析方法
    if (self.configuration && [self.configuration respondsToSelector:@selector(response: completion:)]) {
        YRHttpResponse *tmpResponse = [[YRHttpResponse alloc] initWithResponseObject:responseObject                                     
                                                                          statusCode:0
                                                                             message:_responseMessage
                                                                               error:nil
                                                                             isCache:NO
                                                                         requestType:requestType
                                                                                task:task];
        // 业务方实现的解析方法，获取解析后的数据
        id newResponseObject = [self.configuration response:tmpResponse completion:completion];
        
        
        httpResponse = [[YRHttpResponse alloc] initWithResponseObject:newResponseObject
                                                           statusCode:0
                                                              message:_responseMessage
                                                                error:nil
                                                              isCache:NO
                                                          requestType:requestType
                                                                 task:task];
    } else {
        httpResponse = [[YRHttpResponse alloc] initWithResponseObject:responseObject
                                                           statusCode:0
                                                              message:_responseMessage
                                                                error:nil
                                                              isCache:NO
                                                          requestType:requestType
                                                                 task:task];
        // 执行业务方的回调方法
        if (completion) completion(httpResponse);
    }
    
    // 缓存数据
    if (requestType == YRHttpRequestTypeGet || requestType == YRHttpRequestTypePost) {
        [self saveCacheData:httpResponse.responseObject filePath:url params:params];
    }
    
}


/**
 * 数据请求失败处理
 */
- (YRHttpResponse *)_failureResponse:(NSURLSessionDataTask *)task error:(NSError *)error requestType:(YRHttpRequestType) requestType{
    
//    NSLog(@"*ERROR* request url:%@ error: %@", task.originalRequest.URL.absoluteString, error);
    YRError *yrerror = [YRError errorWithCode:(int)error.code desc:error.description];
    yrerror.desc = @"网络不给力";
    yrerror.originalError = error;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    YRHttpResponse *response = [[YRHttpResponse alloc] initWithResponseObject:nil
                                                                   statusCode:httpResponse.statusCode
                                                                      message:nil
                                                                        error:yrerror
                                                                      isCache:NO
                                                                  requestType:requestType
                                                                         task:task];
    
    if (self.configuration && [self.configuration respondsToSelector:@selector(networkError:)]) {
        [self.configuration networkError:response];
    }
    
    
    return response;
}

- (NSString *)_emptyString:(NSString*)string {
    if ([string isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",string];
    }
    if (!string || ![string length]) {
        return @"";
    } else {
        return string;
    }
}


- (void)_removeTask:(NSURLSessionDataTask *)task {
    [_httpTasks enumerateObjectsUsingBlock:^(YRHttpTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.identifier == task.taskIdentifier) {
            [_httpTasks removeObject:obj];
            *stop = YES;
            obj.taskStatus = YRHttpTaskStatusFinish;
        }
    }];
}


@end

