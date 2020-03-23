//
//  YXDataProcessCenter.m
//  YXEDU
//
//  Created by yao on 2018/10/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDataProcessCenter.h"

@implementation YXDataProcessCenter
+ (YRHttpTask *)GET:(NSString *)url parameters:(NSDictionary *)params finshedBlock:(YXFinishBlock)finishBlock {
   return [[YXNetworkService shared] GET:url parameters:params completion:^(YRHttpResponse *response) {
       BOOL result = response.error ? NO : YES;
       if (finishBlock) {
           finishBlock(response, result);
       }
    }];
}

+ (YRHttpTask *)GET:(NSString *)url modelClass:(Class)modelClass parameters:(NSDictionary *)params finshedBlock:(YXFinishBlock)finishBlock {
    return [self GET:url parameters:params finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (modelClass && result) {
            id data = response.responseObject;
            id model = nil;
            @try {                
                if ([data isKindOfClass:[NSDictionary class]]) {
                    model = [modelClass mj_objectWithKeyValues:data];
//                    NSDictionary *dic = data[@"baseConfig"];
//                    YXBaseConfig *cmolde = [YXBaseConfig mj_objectWithKeyValues:dic];
//                    YXLog(@"%@",cmolde);
                    
                } else if ([data isKindOfClass:[NSArray class]]) {
                    model = [modelClass mj_objectArrayWithKeyValuesArray:data];
                }else{}
            } @catch (NSException *exception) {
                YXLog(@"err = %@", exception);
            } @finally {
            }
            if (model) {
                response = [[YRHttpResponse alloc] initWithResponseObject:model
                                                               statusCode:response.statusCode
                                                                  message:response.message
                                                                    error:response.error
                                                                  isCache:response.isCache
                                                              requestType:response.requestType
                                                                     task:response.sessionTask];
            }
            
        }
        if (finishBlock) {
            finishBlock(response, result);
        }
    }];
}


+ (YRHttpTask *)POST:(NSString *)url parameters:(NSDictionary *)params finshedBlock:(YXFinishBlock)finishBlock {
    return [[YXNetworkService shared] POST:url parameters:params completion:^(YRHttpResponse *response) {
        if (response.error) {
            finishBlock(response, NO);
        } else {
            finishBlock(response, YES);
        }
    }];
}

+ (YRHttpTask *)POST:(NSString *)url modelClass:(Class)modelClass parameters:(NSDictionary *)params finshedBlock:(YXFinishBlock)finishBlock {
    return [self POST:url parameters:params finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (modelClass && result) {
            id data = response.responseObject;
            id model = nil;
            @try {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    model = [modelClass mj_objectWithKeyValues:data];
                } else if ([data isKindOfClass:[NSArray class]]) {
                    model = [modelClass mj_objectArrayWithKeyValuesArray:data];
                }else{}
            } @catch (NSException *exception) {
                YXLog(@"err = %@", exception);
            } @finally {
            }
            if (model) {
                response = [[YRHttpResponse alloc] initWithResponseObject:model
                                                               statusCode:response.statusCode
                                                                  message:response.message
                                                                    error:response.error
                                                                  isCache:response.isCache
                                                              requestType:response.requestType
                                                                     task:response.sessionTask];
            }
            
        }
        if (finishBlock) {
            finishBlock(response, result);
        }
    }];
}

+ (YRHttpTask *)DOWNLOAD:(NSString *)URLString
              parameters:(NSDictionary *)params
                progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
              completion:(YXFinishBlock)finishBlock {
    return [[YXNetworkService shared] download:URLString parameters:params downloadProgress:^(NSProgress *downloadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
    } completion:^(YRHttpResponse *response) {
        BOOL isError = response.error ? NO : YES;
        if (finishBlock) {
            finishBlock(response, isError);
        }
    }];
}

+ (YRHttpTask *)upload:(NSString *)url parameters:(NSDictionary *)params appendFormFiles:(NSArray<YRFormFile *> *)formFiles headers:(NSDictionary *)headers uploadProgress:(YRHttpUploadProgress)progress completion:(YXFinishBlock)finishBlock {
    return [[YXNetworkService shared] upload:url parameters:params appendFormFiles:formFiles headers:headers uploadProgress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } completion:^(YRHttpResponse *response) {
        BOOL isError = response.error ? NO : YES;
        if (finishBlock) {
            finishBlock(response, isError);
        }
    }];
}

+ (void)UPLOAD:(NSString *)url parameters:(NSDictionary *)params datas:(NSArray *)dataArr finshedBlock:(YXFinishBlock)finishBlock {
    NSMutableArray *fileArr = [NSMutableArray array];
    for (int i =0; i<dataArr.count; i++) {
        YRFormFile *formFile = [[YRFormFile alloc]init];
        NSData *imageData = UIImageJPEGRepresentation(dataArr[i], 0.2);
        formFile.name = @"files[]";
        formFile.filename = [NSString stringWithFormat:@"image%ld.jpeg",(long)i];
        formFile.mineType = @"image/jpeg";
        if (!imageData) {
            imageData = UIImagePNGRepresentation(dataArr[i]);
            formFile.filename = [NSString stringWithFormat:@"image%ld.png",(long)i];
            formFile.mineType = @"image/png";
        }
        formFile.data = imageData;
        [fileArr addObject:formFile];
        
    }
    
    [[YXNetworkService shared]upload:url parameters:params appendFormFiles:fileArr headers:nil uploadProgress:^(NSProgress *uploadProgress) {
        
    } completion:^(YRHttpResponse *response) {
        YXLog(@"%@", response.error.originalError);
        BOOL isError = response.error ? NO : YES;
        if (finishBlock) {
            finishBlock(response, isError);
        }
    }];
}
@end
