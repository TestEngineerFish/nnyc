//
//  YXDataProcessCenter.h
//  YXEDU
//
//  Created by yao on 2018/10/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXNetworkService.h"
typedef void (^YXFinishBlock) (YRHttpResponse *response, BOOL result);
NS_ASSUME_NONNULL_BEGIN

@interface YXDataProcessCenter : NSObject
+ (YRHttpTask *)GET:(NSString *) url
         parameters:(NSDictionary *) params
       finshedBlock:(YXFinishBlock)finishBlock;

+ (YRHttpTask *)GET:(NSString *) url
         modelClass:(Class)modelClass
         parameters:(NSDictionary *) params
       finshedBlock:(YXFinishBlock)finishBlock;



+ (YRHttpTask *)POST:(NSString *)url
          parameters:(NSDictionary *) params
        finshedBlock:(YXFinishBlock)finishBlock;

+ (YRHttpTask *)POST:(NSString *)url
          modelClass:(Class)modelClass
          parameters:(NSDictionary *) params
        finshedBlock:(YXFinishBlock)finishBlock;

+ (YRHttpTask *)DOWNLOAD:(NSString *)URLString
      parameters:(NSDictionary *)params
        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
      completion:(YXFinishBlock)finishBlock;

+ (YRHttpTask *)upload:(NSString *)url
            parameters:(NSDictionary *)params
       appendFormFiles:(NSArray<YRFormFile *> *)formFiles
               headers:(NSDictionary *) headers
        uploadProgress:(YRHttpUploadProgress)progress
            completion:(YXFinishBlock)finishBlock;


+ (void)UPLOAD:(NSString *)url
    parameters:(NSDictionary *) params
         datas:(NSArray *)dataArr
  finshedBlock:(YXFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
