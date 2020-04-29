//
//  YXHttpService.m
//  YXEDU
//
//  Created by shiji on 2018/3/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YXConfigure.h"
#import "YXNetworkService.h"
#import "AFNetworking.h"
#import "YXUtils.h"
#import "NSData+YR.h"

@implementation YXResult

@end


@interface YXHttpService ()
@property (nonatomic, strong) YRHttpDownloadTask *downloadTask;
@end

@implementation YXHttpService

+ (instancetype)shared {
    static YXHttpService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXHttpService new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)GET:(NSString *) url
 parameters:(NSDictionary *) params
finshedBlock:(finishBlock)block {
    [[YXNetworkService shared] GET:url parameters:params cache:YRHttpResponseCachePolicyNone useCache:NO completion:^(YRHttpResponse *response) {
        if (response.error) {
            block(@(response.error.code), NO);
        } else {
            block(response.responseObject, YES);
        }
    }];
    
}

- (void)POST:(NSString *)url
  parameters:(NSDictionary *) params
finshedBlock:(finishBlock)block {\
    [[YXNetworkService shared] POST:url parameters:params cache:YRHttpResponseCachePolicyNone useCache:NO completion:^(YRHttpResponse *response) {
        if (response.error) {
            block(@(response.error.code), NO);
        } else {
            block(response.responseObject, YES);
        }
    }];
}

- (void)UPLOAD:(NSString *)url
    parameters:(NSDictionary *) params
         datas:(NSArray *)dataArr
  finshedBlock:(finishBlock)block {
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
        if (response.error) {
            block(response.error, NO);
        } else {
            block(nil, YES);
        }
    }];
}
    

- (void)POST:(NSString *)url
  parameters:(NSDictionary *) params
       datas:(NSArray *)dataArr
finshedBlock:(finishBlock)block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSInteger idx = 0;
        for (NSData *imageData in dataArr) {
            [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"photos[%ld]",(long)idx]
                                    fileName:[NSString stringWithFormat:@"image%ld.png",(long)idx]
                                    mimeType:@"image/png"];
            idx ++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(task.response, YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(error, NO);
    }];
}


- (void)DOWNLOAD:(NSString *)URLString
     dstFilePath:(NSString *)dstFilePath
        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
      completion:(void (^)(id responseObject))completionBlock {
    NSString *tmpDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[[URLString dataUsingEncoding:NSUTF8StringEncoding]md5String]];
    self.downloadTask = [[YXNetworkService shared]download:URLString parameters:nil headers:nil tmpFilePath:tmpDir dstFilePath:dstFilePath downloadProgress:^(NSProgress *downloadProgress) {
        downloadProgressBlock(downloadProgress);
    } completion:^(YRHttpResponse *response) {
        completionBlock(response);
    }];
}

- (void)CANCEL {
    [self.downloadTask cancelTask];
}

- (void)DOWNLOAD:(NSString *)URLString
      parameters:(NSDictionary *)params
        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
      completion:(void (^)(id responseObject))completionBlock {
    
    [[YXNetworkService shared]download:URLString parameters:params headers:nil downloadProgress:^(NSProgress *downloadProgress) {
        downloadProgressBlock(downloadProgress);
    } completion:^(YRHttpResponse *response) {
        completionBlock(response.responseObject);
    }];
}

@end
