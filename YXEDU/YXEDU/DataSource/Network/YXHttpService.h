//
//  YXHttpService.h
//  YXEDU
//
//  Created by shiji on 2018/3/30.
//  Copyright © 2018年 shiji. All rights reserved.
//
// processor
//#import <YRNetwork/YRNetwork.h>
#import "YRNetwork.h"
#import "YXAPI.h"

@interface YXResult : NSObject
@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, strong) NSString *warning;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSDictionary *data;
@end

@interface YXHttpService : NSObject
+ (instancetype)shared;

- (void)GET:(NSString *) url
 parameters:(NSDictionary *) params
finshedBlock:(finishBlock)block;

- (void)POST:(NSString *)url
  parameters:(NSDictionary *) params
finshedBlock:(finishBlock)block;

- (void)POST:(NSString *)url
  parameters:(NSDictionary *) params
       datas:(NSArray *)dataArr
finshedBlock:(finishBlock)block;

- (void)UPLOAD:(NSString *)url
    parameters:(NSDictionary *) params
         datas:(NSArray *)dataArr
  finshedBlock:(finishBlock)block;

- (void)DOWNLOAD:(NSString *)URLString
     dstFilePath:(NSString *)dstFilePath
        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
      completion:(void (^)(id responseObject))completionBlock;

- (void)CANCEL;

- (void)DOWNLOAD:(NSString *)URLString
      parameters:(NSDictionary *)params
        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
      completion:(void (^)(id responseObject))completionBlock;

@end
